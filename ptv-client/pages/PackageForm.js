import React, {useState, useContext} from 'react';
import TextField from '@mui/material/TextField';
import Grid from '@mui/material/Grid'
import Typography from '@mui/material/Typography'
import PickUpAddr from './PickUpAddr'
// to get live time
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import LocalizationProvider from '@mui/lab/LocalizationProvider';
import { TimePicker } from '@mui/lab';



const PackageForm = () =>{


    return(
        // <LocalizationProvider DateAdapter={DateAdapter}>
        <div>
            <LocalizationProvider dateAdapter={AdapterDateFns}>
                <Grid container spacing={2}>
                    <Grid item xs={8}>
                        <Typography variant='h5'>Please register the packet you want to be delivered</Typography>
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
                
            </LocalizationProvider>

        </div>
        // </LocalizationProvider>
    );
}
export default PackageForm;