provides "gpu"

gpu_output = `lspci | grep 3D`
#gpu_output = "05:00.0 3D controller: NVIDIA Corporation GK210GL [Tesla K80] (rev a1)\n06:00.0 3D controller: NVIDIA Corporation GK210GL [Tesla K80] (rev a1)\n"
#gpu_output = "03:00.0 3D controller: NVIDIA Corporation Device 17fd (rev a1)"

if gpu_output['NVIDIA']
  nvidia_output = `nvidia-smi -L`
  gpu_info_str = nvidia_output.split("\n")[-1].split()
  gpu_model = gpu_info_str[3]
  gpu_count = gpu_info_str[1].sub ':', ''
  gpu_count = gpu_count.to_i + 1

  if gpu_model.include? 'P100'
    gpu_model = 'P100'
  end

  gpu_info = {
      :gpu => true,
      :gpu_model => gpu_model,
      :gpu_vendor => 'NVIDIA',
      :gpu_count => gpu_count
  }
elsif gpu_output['AMD']
  gpu_lines = gpu_output.split('\n')
  gpu_count = gpu_lines.length

  begin
    gpu_model_info = gpu_lines[-1][/\[.*\]/].tr('[]', '')
    gpu_model = gpu_model_info[1]
  rescue
    gpu_model = 'Unknown'
  end

  gpu_info = {
      :gpu => true,
      :gpu_model => gpu_model,
      :gpu_vendor => 'AMD',
      :gpu_count => gpu_count
  }
else
  gpu_info = {
      :gpu => false
  }
end

gpu gpu_info
