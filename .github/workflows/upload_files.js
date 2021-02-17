var uploadUrl = core.getInput('upload_url', { required: false, default: ''});

// Useful when manually triggered
if (uploadUrl === '') {
    var release;

    const rel = core.getInput('release', { required: false, default: '' });

    if (rel === '') {
        release = github.repos.getLatestRelease({
            owner: github.context.repo.owner,
            repo: github.context.repo.repo,
        });
    } else {
        release = github.repos.getRelease({
            owner: github.context.repo.owner,
            repo: github.context.repo.repo,
            release: rel,
        });
    }
    uploadUrl = release.data.upload_url;
}

# It sounds that this needs to be hardcoded with this version
const asset_path = 'LICENSE';
const asset_name = 'LICENSE';
const asset_content_type = 'application/text';

//const assetPath = core.getInput('asset_path', { required: true });
//const assetName = core.getInput('asset_name', { required: true });
//const assetContentType = core.getInput('asset_content_type', { required: true });

// Determine content-length for header to upload asset
const contentLength = filePath => fs.statSync(filePath).size;

// Setup headers for API call,
// see Octokit Documentation:
// https://octokit.github.io/rest.js/#octokit-routes-repos-upload-on-trigger for more information
const headers = { 'content-type': assetContentType, 'content-length': contentLength(assetPath) };

// Upload a release asset
// API Documentation: https://developer.github.com/v3/repos/releases/#upload-a-release-asset
// Octokit Documentation: https://octokit.github.io/rest.js/#octokit-routes-repos-upload-on-trigger
const uploadAssetResponse = await github.repos.uploadReleaseAsset({
    url: uploadUrl,
    headers,
    name: assetName,
    file: fs.readFileSync(assetPath)
});

// Get the browser_download_url for the uploaded release asset from the response
const {
    data: { browser_download_url: browserDownloadUrl }
} = uploadAssetResponse;

// Set the output variable for use by other actions: https://github.com/actions/toolkit/tree/master/packages/core#inputsoutputs
core.setOutput('browser_download_url', browserDownloadUrl);
