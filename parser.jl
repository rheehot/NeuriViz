using CSV
using DataFrames
using MAT

#= 

        # Description: 
        
        `set` files are actually just `mat` files in disguise. [1] One can use MAT.jl to read in these files as a dict with the keys as variables. These files serve as header files which give information about the more important data filetype, `.fdt` files. 

        # References:

        1.  https://sccn.ucsd.edu/pipermail/eeglablist/2012/005680.html   

=# 

mat_file = "../data/ds002680-download/sub-002/ses-01/eeg/sub-002_ses-01_task-gonogo_run-01_eeg.set" 

eeg_run_info = matread(mat_file)["EEG"]

#= 

        # Description:

        `tsv` are simply tab separated values. These files serve to show how many electrodes were used and where they were attached on the skull.

=#

electrodes_bin = "../data/ds002680-download/sub-002/ses-01/eeg/sub-002_ses-01_task-gonogo_run-01_electrodes.tsv"

electrodes = CSV.read(electrodes_bin, DataFrame) 

#= 
        
        # Description:

        `fdt` files are a type of binary file format that stores "float data". [1] They are not natively able to be read by Julia so we have to make a binary reader. This binary reader was inspired from the EEGLAB project [2] and a Julia Discourse discussion on reading binary data. [3] The resulting dataframe is the number of electrode channels available by the number of samples recorded. 

        NOTE: the sample rate is 1000 Hz - this comes from the `set` file.

        # References: 

        1. https://sccn.ucsd.edu/pipermail/eeglablist/2012/005184.html
        
        2. https://sccn.ucsd.edu/wiki/Makoto%27s_useful_EEGLAB_code#How_to_load_EEGLAB_.set_and_.fdt_files_without_using_EEGLAB_.2805.2F09.2F2020_updated.29
        
        3. https://discourse.julialang.org/t/read-binary-data-of-arbitrary-dims-and-type/28560

=#
fdt_bin = "../data/ds002680-download/sub-002/ses-01/eeg/sub-002_ses-01_task-gonogo_run-01_eeg.fdt"

data = open(fdt_bin) do io
           read!(io, Array{Float32}(undef, (Int(mat["EEG"]["nbchan"]), Int(mat["EEG"]["pnts"]))))
       end

df = DataFrame(data)
