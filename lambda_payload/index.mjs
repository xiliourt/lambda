import https from 'https';

export const handler = async (event) => {
    // --- 1. Configuration ---
    const TIMEOUT_MS = 2500; // 2.5 seconds hard limit
    let targetUrl = null;

    if (event.url) targetUrl = event.url;
    else if (event.queryStringParameters?.url) targetUrl = event.queryStringParameters.url;
    else targetUrl = process.env.TARGET_URL;

    if (!targetUrl) {
        return { statusCode: 400, body: "Error: Missing 'url' parameter." };
    }

    try {
        // --- 2. Perform Download with Timeout ---
        const result = await downloadWithTimeout(targetUrl, TIMEOUT_MS);
        
        // --- 3. Calculate Speed (Mbps) ---
        // Formula: (Bytes * 8) / (Seconds * 1,000,000)
        const bits = result.bytes * 8;
        const megaBits = bits / 1000000;
        const mbps = (megaBits / result.duration).toFixed(2);

        // --- 4. Format Output ---
        const statusTag = result.complete ? "(Complete)" : "(Timed out at 2.5s)";
        
        return {
            statusCode: 200,
            headers: { 
                "Content-Type": "text/plain",
                "X-Cache-Status": result.cacheStatus
            },
            body: `Cache Status: ${result.cacheStatus}\n` +
                  `State:        ${statusTag}\n` +
                  `Time Taken:   ${result.duration} seconds\n` +
                  `Downloaded:   ${(result.bytes / 1024 / 1024).toFixed(2)} MB\n` +
                  `Speed:        ${mbps} Mbps`
        };

    } catch (error) {
        console.error(error);
        return { statusCode: 500, body: `Error: ${error.message}` };
    }
};

function downloadWithTimeout(urlStr, timeoutMs) {
    return new Promise((resolve, reject) => {
        const options = { method: 'GET', headers: { 'User-Agent': 'AWS-Lambda-Monitor' } };
        const startTime = Date.now();
        let bytes = 0;
        let isResolved = false;

        const req = https.request(urlStr, options, (res) => {
            const cacheStatus = res.headers['cf-cache-status'] || 'MISS/UNKNOWN';

            // 1. Data Listener
            res.on('data', (chunk) => {
                bytes += chunk.length;
            });

            // 2. Completion Listener
            res.on('end', () => {
                if (isResolved) return; // Ignore if timeout already happened
                isResolved = true;
                
                const duration = ((Date.now() - startTime) / 1000).toFixed(3);
                resolve({
                    complete: true,
                    cacheStatus,
                    bytes,
                    duration
                });
            });
        });

        // 3. The "2.5s" Safety Timer
        const timeoutId = setTimeout(() => {
            if (isResolved) return; // Ignore if download finished exactly at the buzzer
            isResolved = true;

            req.destroy(); // Kill the connection immediately
            
            const duration = ((Date.now() - startTime) / 1000).toFixed(3);
            
            // Resolve with whatever data we got so far
            // Note: We might not know the cache status if headers never arrived, 
            // but usually headers arrive well before 2.5s.
            resolve({
                complete: false,
                cacheStatus: req.res ? req.res.headers['cf-cache-status'] || 'UNKNOWN' : 'TIMEOUT_BEFORE_HEADERS',
                bytes,
                duration
            });
        }, timeoutMs);

        req.on('error', (err) => {
            if (isResolved) return; // Ignore errors caused by our own req.destroy()
            clearTimeout(timeoutId);
            reject(err);
        });

        req.end();
    });
}
