use std::fs::File;
use std::io::{BufReader, BufWriter, Write, Result};
use byteorder::{LittleEndian, ReadBytesExt};

pub fn read_binary(file_path: &str)
    -> Result<(Vec<f64>, Vec<f64>, Vec<f64>, f64, Vec<f64>)> {
    let mut file = BufReader::new(File::open(file_path)?);

    // Read the number of rows (n) as u32
    let n = file.read_u32::<LittleEndian>()?;
    let n = n as usize;
    
    let mut s = vec![0.0; n];
    let mut k = vec![0.0; n];
    let mut t = vec![0.0; n];
    let r = file.read_f64::<LittleEndian>()?;
    let mut c = vec![0.0; n];

    // Read the matrix
    let mut matrix_data = vec![0f64; (n * 4) as usize];
    for value in matrix_data.iter_mut() {
        *value = file.read_f64::<LittleEndian>()?;
    }

    // Optionally, convert the flat array into a 2D vector if needed
    let matrix: Vec<Vec<f64>> = matrix_data
        .chunks_exact(4)
        .map(|chunk| chunk.to_vec())
        .collect();

    for (i, row) in matrix.iter().enumerate() {
        if i < n {
            c[i] = row[0];
            k[i] = row[1];
            s[i] = row[2];
            t[i] = row[3];
        }
    }

    Ok((s, k, t, r, c))
}

pub fn write_binary(data: &Vec<f64>, path: &str) -> Result<()> {
    // Step 1: Open a file
    let file = File::create(path)?;

    // Step 2: Create a BufWriter
    let mut writer = BufWriter::new(file);

    // Step 3: Write each f64 to the file in binary format
    for &value in data {
        let bytes: [u8; 8] = value.to_le_bytes(); // to_le_bytes for little-endian
        writer.write_all(&bytes)?;
    }

    writer.flush()?; // Ensure all data is written to the disk
    Ok(())
}
