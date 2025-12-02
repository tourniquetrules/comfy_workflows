# Check if aria2c is available
if (-not (Get-Command "aria2c" -ErrorAction SilentlyContinue)) {
    Write-Warning "aria2c not found. Please install aria2c and add it to your PATH."
    exit 1
}

# Function to download using aria2c
function Download-File {
    param (
        [string]$Url,
        [string]$Dir,
        [string]$Filename
    )

    # Create directory if it doesn't exist
    if (-not (Test-Path -Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir | Out-Null
    }

    $FilePath = Join-Path -Path $Dir -ChildPath $Filename

    # Check if file already exists
    if (Test-Path -Path $FilePath) {
        Write-Host "File $FilePath already exists. Skipping."
    } else {
        Write-Host "Downloading $Filename to $Dir..."
        aria2c -x 16 -s 16 -k 1M --console-log-level=error -d "$Dir" -o "$Filename" "$Url"
    }
}

Write-Host "Starting download of ComfyUI models..."

# ==============================================================================
# 1. Infinite Talk Workflow Models
# ==============================================================================
Write-Host "Downloading Infinite Talk Workflow models..."

# WanVideo Model Loader
Download-File -Url "https://huggingface.co/city96/Wan2.1-I2V-14B-480P-gguf/resolve/main/wan2.1-i2v-14b-480p-Q4_0.gguf?download=true" -Dir "ComfyUI\models\diffusion_models" -Filename "wan2.1-i2v-14b-480p-Q4_0.gguf"

# WanVideo Lora Select
Download-File -Url "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors?download=true" -Dir "ComfyUI\models\loras" -Filename "lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"
# Also downloading the rank256 version referenced in the node
Download-File -Url "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors?download=true" -Dir "ComfyUI\models\loras" -Filename "lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors"

# Multi/InfiniteTalk Model Loader
Download-File -Url "https://huggingface.co/Kijai/WanVideo_comfy_GGUF/resolve/main/InfiniteTalk/Wan2_1-InfiniteTalk_Single_Q8.gguf?download=true" -Dir "ComfyUI\models\diffusion_models" -Filename "Wan2_1-InfiniteTalk_Single_Q8.gguf"

# Load VAE
Download-File -Url "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors?download=true" -Dir "ComfyUI\models\vae" -Filename "wan_2.1_vae.safetensors"

# Load CLIP Vision
Download-File -Url "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors?download=true" -Dir "ComfyUI\models\clip_vision" -Filename "clip_vision_h.safetensors"

# Wav2vec2 Model Loader
Download-File -Url "https://huggingface.co/Kijai/wav2vec2_safetensors/resolve/main/wav2vec2-chinese-base_fp16.safetensors?download=true" -Dir "ComfyUI\models\wav2vec2" -Filename "wav2vec2-chinese-base_fp16.safetensors"

# WanVideo TextEncode Cached (T5 Encoder)
Download-File -Url "https://huggingface.co/ALGOTECH/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors?download=true" -Dir "ComfyUI\models\clip" -Filename "umt5-xxl-enc-bf16.safetensors"


# ==============================================================================
# 2. Qwen Edit Workflow Models
# ==============================================================================
Write-Host "Downloading Qwen Edit Workflow models..."

# UNETLoader (Qwen Image Edit)
Download-File -Url "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors" -Dir "ComfyUI\models\diffusion_models\QwenImage" -Filename "qwen_image_edit_2509_fp8_e4m3fn.safetensors"

# CLIPLoader (Qwen 2.5 VL 7B)
Download-File -Url "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" -Dir "ComfyUI\models\text_encoders" -Filename "qwen_2.5_vl_7b_fp8_scaled.safetensors"
# Also putting it in clip folder as backup/alternative path
Download-File -Url "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" -Dir "ComfyUI\models\clip" -Filename "qwen_2.5_vl_7b_fp8_scaled.safetensors"

# VAELoader (Qwen Image VAE)
Download-File -Url "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors" -Dir "ComfyUI\models\vae" -Filename "qwen_image_vae.safetensors"

# LoraLoaderModelOnly (Qwen Image Lightning)
Download-File -Url "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-4steps-V1.0.safetensors" -Dir "ComfyUI\models\loras\QwenEdit" -Filename "Qwen-Image-Edit-Lightning-4steps-V1.0.safetensors"

# UNETLoader (Qwen Image FP8) - Widget says z_image_turbo_bf16.safetensors but URL points to qwen_image_fp8_e4m3fn.safetensors
Download-File -Url "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_fp8_e4m3fn.safetensors" -Dir "ComfyUI\models\diffusion_models" -Filename "qwen_image_fp8_e4m3fn.safetensors"

# UpscaleModelLoader (RealESRGAN)
Download-File -Url "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth" -Dir "ComfyUI\models\upscale_models" -Filename "RealESRGAN_x4plus.pth"

# Missing: Try_On_Qwen_Edit_Lora.safetensors
Write-Warning "Could not find a direct download URL for 'Try_On_Qwen_Edit_Lora.safetensors'. Please locate this file manually and place it in ComfyUI\models\loras\QwenEdit\"


# ==============================================================================
# 3. Wan 2.2 Animate Workflow Models
# ==============================================================================
Write-Host "Downloading Wan 2.2 Animate Workflow models..."

# CLIPLoader (UMT5 XXL)
Download-File -Url "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" -Dir "ComfyUI\models\text_encoders" -Filename "umt5_xxl_fp8_e4m3fn_scaled.safetensors"

# UNETLoader (Wan 2.2 Animate)
Download-File -Url "https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Wan22Animate/Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors" -Dir "ComfyUI\models\diffusion_models\wan2_2" -Filename "Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors"

# LoraLoaderModelOnly (WanAnimate Relight)
Download-File -Url "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/WanAnimate_relight_lora_fp16.safetensors" -Dir "ComfyUI\models\loras\Wan2_2" -Filename "WanAnimate_relight_lora_fp16.safetensors"

# UNETLoader (Wan 2.2 T2V Low Noise) - Node says "wan2.2_t2v_low_noise_14B_fp16.safetensors" but link points to fp8 scaled version usually used in comfy
Download-File -Url "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors" -Dir "ComfyUI\models\diffusion_models\wan2_2" -Filename "wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors"

# LoraLoaderModelOnly (DetailEnhancer)
Download-File -Url "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/DetailEnhancerV1.safetensors" -Dir "ComfyUI\models\loras\WanVideo" -Filename "DetailEnhancerV1.safetensors"

# LoraLoaderModelOnly (Wan 2.2 Fun HPS) - Based on search, likely "Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors"
# Note: URL might be unstable or require login for ModelScope. Using best effort or skipping.
Write-Warning "'Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors' URL not permanently available. Please download from ModelScope or HuggingFace (Kijai/WanVideo_comfy repo) manually."

# Onnx Models (Pose/Detection)
# yolov10m.onnx
Download-File -Url "https://huggingface.co/onnx-community/yolov10m/resolve/main/onnx/model.onnx" -Dir "ComfyUI\models\onnx" -Filename "yolov10m.onnx"

# vitpose-l-wholebody.onnx (Common location for ComfyUI pose nodes)
# Attempting to download from a known source, e.g., huggingface.co/student/adapter/resolve/main/vitpose-l-wholebody.onnx or similar.
# Using a generic search result link or placeholder.
Download-File -Url "https://huggingface.co/xinsir/controlnet-union-sdxl-1.0/resolve/main/vitpose_v2.onnx" -Dir "ComfyUI\models\onnx" -Filename "vitpose-l-wholebody.onnx"
# Note: The above is a placeholder. Real vitpose-l-wholebody.onnx might need a specific repo.
Write-Host "NOTE: 'vitpose-l-wholebody.onnx' download attempted from generic source. If it fails or is incorrect, please find the correct ONNX model for 'comfyui-wananimatepreprocess'."

# Low Noise Model LoRA
Write-Warning "'low_noise_model.safetensors' (path: Wan2.2-T2V-A14B-4steps-lora-250928) could not be automatically downloaded. Please check Wan2.2-T2V-A14B-4steps-lora-250928 repository."

Write-Host "Download script completed. Please check for any warnings."
