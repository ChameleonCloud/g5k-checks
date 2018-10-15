provides "gpu"

gpu_output = `lscpi | grep 3D`
#gpu_output = "05:00.0 3D controller: NVIDIA Corporation GK210GL [Tesla K80] (rev a1)\n06:00.0 3D controller: NVIDIA Corporation GK210GL [Tesla K80] (rev a1)\n"
#gpu_output = "03:00.0 3D controller: NVIDIA Corporation Device 17fd (rev a1)"

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#  EXAMPLE `nvidia-smi -L` OUTPUT BY GPU TYPE:
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# m40:
# GPU 0: Tesla M40 (UUID: GPU-77e0d2b9-0e37-fbae-d1c3-fd8cee7a5289)
#
# k80
# GPU 0: Tesla K80 (UUID: GPU-c43b0acd-16a5-e464-7b56-6a27600c1aaf)
# GPU 1: Tesla K80 (UUID: GPU-5b556b1a-341c-9d5a-1e0b-791c7b7d5dc8)
#
# p100:
# GPU 0: Tesla P100-PCIE-16GB (UUID: GPU-da98d1a0-8c55-6d25-3cd8-265005e40bff)
# GPU 1: Tesla P100-PCIE-16GB (UUID: GPU-55f4d3c8-9d58-3c18-be6e-c9581cd8a7a8)
#
# p100_nvlink
# GPU 0: Tesla P100-SXM2-16GB (UUID: GPU-9d6d38b0-4256-7181-53f8-0de2a51c8623)
# GPU 1: Tesla P100-SXM2-16GB (UUID: GPU-f18428f3-3231-6ad2-e860-64422c2edec4)
# GPU 2: Tesla P100-SXM2-16GB (UUID: GPU-0822d3d7-2471-60b4-c120-e795ea2940fa)
# GPU 3: Tesla P100-SXM2-16GB (UUID: GPU-b39c8a2b-1df3-d7ac-64c4-6c71591e8bb4)
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
