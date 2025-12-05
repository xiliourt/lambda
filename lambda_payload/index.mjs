import https from 'https';

export const handler = async (event) => {
    // --- 1. Configuration ---
    const TIMEOUT_MS = 2500; 
    let targetUrl = null;

    if (event.url) targetUrl = event.url;
    else if (event.queryStringParameters?.url) targetUrl = event.queryStringParameters.url;
    else targetUrl = process.env.TARGET_URL;

    if (!targetUrl) {
        return { 
            statusCode: 400, 
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ error: "Missing 'url' parameter." }) 
        };
    }

    try {
        // --- 2. Perform Download ---
        const result = await downloadWithTimeout(targetUrl, TIMEOUT_MS);
        
        // --- 3. Calculate Speed ---
        const bits = result.bytes * 8;
        const megaBits = bits / 1000000;
        const mbps = result.duration > 0 ? (megaBits / result.duration).toFixed(2) : "0.00"; 
        const downloadedMB = (result.bytes / 1024 / 1024).toFixed(2);

        const responseData = {
            cache_status: result.cacheStatus,
            complete: result.complete,
            message: result.complete ? "Complete" : "Timed out at 2.5s",
            time_taken_seconds: parseFloat(result.duration),
            downloaded_mb: parseFloat(downloadedMB),
            downloaded_bytes: result.bytes,
            speed_mbps: parseFloat(mbps)
        };
        
        return {
            statusCode: 200,
            headers: { 
                "Content-Type": "application/json",
                "X-Cache-Status": result.cacheStatus
                // REMOVED: "Access-Control-Allow-Origin": "*" 
                // Terraform handles this now!
            },
            body: JSON.stringify(responseData)
        };

    } catch (error) {
        console.error(error);
        return { 
            statusCode: 500, 
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ error: error.message }) 
        };
    }
};

function downloadWithTimeout(urlStr, timeoutMs) {
    // ... (Keep this helper function exactly the same) ...
    return new Promise((resolve, reject) => {
        const options = { method: 'GET', headers: { 'User-Agent': 'AWS-Lambda-Monitor' } };
        const startTime = Date.now();
        let bytes = 0;
        let isResolved = false;

        const req = https.request(urlStr, options, (res) => {
            const cacheStatus = res.headers['cf-cache-status'] || 'MISS/UNKNOWN';
            res.on('data', (chunk) => { bytes += chunk.length; });
            res.on('end', () => {
                if (isResolved) return;
                isResolved = true;
                const duration = ((Date.now() - startTime) / 1000).toFixed(3);
                resolve({ complete: true, cacheStatus, bytes, duration });
            });
        });

        const timeoutId = setTimeout(() => {
            if (isResolved) return;
            isResolved = true;
            const currentRes = req.res; 
            const timeoutCacheStatus = currentRes && currentRes.headers ? (currentRes.headers['cf-cache-status'] || 'UNKNOWN') : 'TIMEOUT_BEFORE_HEADERS';
            req.destroy();
            const duration = ((Date.now() - startTime) / 1000).toFixed(3);
            resolve({ complete: false, cacheStatus: timeoutCacheStatus, bytes, duration });
        }, timeoutMs);

        req.on('error', (err) => {
            if (isResolved) return;
            clearTimeout(timeoutId);
            reject(err);
        });
        req.end();
    });
}
