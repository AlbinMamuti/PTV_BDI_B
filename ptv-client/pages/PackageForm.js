import React from 'react';
import TextField from '@mui/material/TextField';
import Grid from '@mui/material/Grid'
import Typography from '@mui/material/Typography'
import PickUpAddr from './PickUpAddr'



const PackageForm = () =>{
    return(
        <div>
            <Grid container spacing={2}>
                <Grid item xs={8}>
                    <Typography variant='h5'>Please register your packet you want to be delivered</Typography>
                </Grid>
                <Grid item xs={8}>
                    <TextField
                    required
                    id="outlined-required"
                    label="Packet-Description"
                    fullWidth
                    />
                </Grid>
                <Grid item xs={4}></Grid>
                <Grid item xs={12}>
                <PickUpAddr></PickUpAddr>
                </Grid>
                
            </Grid>

        </div>
    );
}
export default PackageForm;