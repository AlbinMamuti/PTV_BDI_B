import React, {useState, useContext, createContext} from 'react';
import PickUpAddr from './PickUpAddr'
import FormHelperText from '@mui/material/FormHelperText';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';

import { Button, TextField, Grid, Typography, Stack } from '@mui/material';

import {SendIcon, DeleteIcon} from '@mui/icons-material'

// to get live time
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import LocalizationProvider from '@mui/lab/LocalizationProvider';


export const PickData = createContext()


const PackageForm = () =>{

 
    const [clientPickData, setClientPickData] = useState("")

    const [description, setDescription] = useState("")
    const [pickupPriority, setPickupPriority] = useState("");


    const insertDB = () =>{
        console.log("Es funktionaglet")
        console.log(clientPickData)
    }
    const handleChange = (event) => {
        setPickupPriority(event.target.value);
        console.log(pickTime)
      };

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
                        onChange={(newValue) => {
                            setDescription(newValue);
                        }}
                        fullWidth
                        />
                    </Grid>
                    <Grid item xs={4}></Grid>
                    <Grid item xs={12}>
                        <PickData.Provider value={[clientPickData, setClientPickData]}>
                            <PickUpAddr></PickUpAddr>
                        </PickData.Provider>
                    </Grid>
                    <Grid item xs = {12}>
                    <Stack direction="row" justifyContent="center">
                        <FormControl sx={{ m: 1, minWidth: 120 }}>
                        <InputLabel id="pickup-priority-helper-label">Priority</InputLabel>
                        <Select
                        labelId="pickup-priority-helper-label"
                        id="pickup-priority-select-helper"
                        value={pickupPriority}
                        label="Priority"
                        onChange={handleChange}
                        required
                        >
                        <MenuItem value="">
                            <em>None</em>
                        </MenuItem>
                        <MenuItem value={1}>1</MenuItem>
                        <MenuItem value={2}>2</MenuItem>
                        <MenuItem value={3}>3</MenuItem>
                        <MenuItem value={4}>4</MenuItem>
                        <MenuItem value={5}>5</MenuItem>
                        <MenuItem value={6}>6</MenuItem>
                        <MenuItem value={7}>7</MenuItem>
                        <MenuItem value={8}>8</MenuItem>
                        <MenuItem value={9}>9</MenuItem>
                        </Select>
                        <FormHelperText>Price will be calculated based on distance and priority</FormHelperText>
                        </FormControl>
                    </Stack>
                </Grid>
                    <Grid item xs = {6}>
                        <Button variant="outlined">Delete</Button>
                    </Grid>
                    <Grid item xs = {6}>
                        <Stack direction="row" justifyContent="end">
                            <Button 
                            variant="contained"
                            onClick={insertDB}
                            >Submit</Button>
                        </Stack>
                    </Grid>
                </Grid>
                
            </LocalizationProvider>

        </div>
    );
}
export default PackageForm;