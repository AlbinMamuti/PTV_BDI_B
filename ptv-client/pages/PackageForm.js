import React, { useState, useContext, createContext } from "react";
import PickUpAddr from "./PickUpAddr";
import FormHelperText from "@mui/material/FormHelperText";
import FormControl from "@mui/material/FormControl";
import Select from "@mui/material/Select";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";

import TimePicker from "@mui/lab/TimePicker";

import { Button, TextField, Grid, Typography, Stack } from "@mui/material";

import { SendIcon, DeleteIcon } from "@mui/icons-material";

// to get live time
import AdapterDateFns from "@mui/lab/AdapterDateFns";
import LocalizationProvider from "@mui/lab/LocalizationProvider";

const PackageForm = () => {
        //   const [clientPickData, setClientPickData] = useState("");

        const [description, setDescription] = useState("");
        const [pickupPriority, setPickupPriority] = useState("");
        const [pickTimeStart, setPickTimeStart] = useState("");
        const [pickTimeEnd, setPickTimeEnd] = useState("");
        const [pickAddress1, setPickAddress1] = useState("");
        const [pickAddress2, setPickAddress2] = useState("");
        const [pickCity, setPickCity] = useState("");
        const [pickZip, setPickZip] = useState("");
        const [pickState, setPickState] = useState("");

        const insertDB = () => {
            console.log("Es funktionaglet");
            console.log(pickAddress1);
        };
        const handleChange = (event) => {
            setPickupPriority(event.target.value);
            console.log(pickTimeStart);
        };

        return (
                // <LocalizationProvider DateAdapter={DateAdapter}>
                <
                div >
                <
                LocalizationProvider dateAdapter = { AdapterDateFns } >
                <
                Grid container spacing = { 2 } >
                <
                Grid item xs = { 8 } >
                <
                Typography variant = "h5" >
                Please register the packet you want to be delivered <
                /Typography> <
                /Grid> <
                Grid item xs = { 8 } >
                <
                TextField required id = "outlined-required"
                label = "Packet-Description"
                onChange = {
                    (event) => {
                        setDescription(event.target.value);
                    }
                }
                fullWidth /
                >
                <
                /Grid> <
                Grid item xs = { 4 } > < /Grid> <
                Grid item xs = { 12 } >
                <
                Grid container spacing = { 1 } >
                <
                Grid item xs = { 12 } >
                <
                Typography variant = "h4" > PickUp - Addr < /Typography> <
                /Grid> { /* begin pickup address form */ } <
                Grid item xs = { 8 } >
                <
                TextField required id = "outlined-required"
                label = "Address Line 1"
                onChange = {
                    (event) => {
                        setPickAddress1(event.target.value);
                    }
                }
                fullWidth /
                >
                <
                /Grid> <
                Grid item xs = { 8 } >
                <
                TextField id = "outlined-required"
                label = "Address Line 2"
                onChange = {
                    (event) => {
                        setPickAddress2(event.target.value);
                    }
                }
                fullWidth /
                >
                <
                /Grid> <
                Grid item xs = { 8 } >
                <
                TextField required id = "outlined-required"
                label = "City"
                onChange = {
                    (event) => {
                        setPickCity(event.target.value);
                    }
                }
                fullWidth /
                >
                <
                /Grid> <
                Grid item xs = { 6 } >
                <
                TextField required id = "outlined-required"
                label = "State"
                onChange = {
                    (event) => {
                        setPickState(event.target.value);
                    }
                }
                fullWidth /
                >
                <
                /Grid> <
                Grid item xs = { 6 } >
                <
                TextField required id = "outlined-required"
                label = "ZIP"
                onChange = {
                    (event) => {
                        setPickZIP(event.target.value);
                    }
                }
                fullWidth /
                >
                <
                /Grid> <
                Grid item xs = { 6 } >
                <
                TimePicker label = "PickupTime Start"
                value = { pickTimeStart.start }
                onChange = {
                    (event) => {
                        setPickTimeStart(event.target.value);
                    }
                }
                renderInput = {
                    (params) => < TextField {...params }
                    />} /
                    >
                    <
                    /Grid> {
                        /* <Grid item xs = {1}>
                                            <Typography variant='h5'>to</Typography>
                                        </Grid> */
                    } <
                    Grid item xs = { 6 } >
                    <
                    TimePicker
                    label = "PickupTime End"
                    value = { pickTimeEnd.start }
                    onChange = {
                        (event) => {
                            setPickTimeEnd(event.target.value);
                        }
                    }
                    renderInput = {
                        (params) => < TextField {...params }
                        />} /
                        >
                        <
                        /Grid> <
                        /Grid> { /* end pickup form */ } <
                        /Grid> <
                        Grid item xs = { 12 } >
                        <
                        Stack direction = "row"
                        justifyContent = "center" >
                        <
                        FormControl sx = {
                            { m: 1, minWidth: 120 } } >
                        <
                        InputLabel id = "pickup-priority-helper-label" >
                        Priority <
                        /InputLabel> <
                        Select
                        labelId = "pickup-priority-helper-label"
                        id = "pickup-priority-select-helper"
                        value = { pickupPriority }
                        label = "Priority"
                        onChange = { handleChange }
                        required >
                        <
                        MenuItem value = "" >
                        <
                        em > None < /em> <
                        /MenuItem> <
                        MenuItem value = { 1 } > 1 < /MenuItem> <
                        MenuItem value = { 2 } > 2 < /MenuItem> <
                        MenuItem value = { 3 } > 3 < /MenuItem> <
                        MenuItem value = { 4 } > 4 < /MenuItem> <
                        MenuItem value = { 5 } > 5 < /MenuItem> <
                        MenuItem value = { 6 } > 6 < /MenuItem> <
                        MenuItem value = { 7 } > 7 < /MenuItem> <
                        MenuItem value = { 8 } > 8 < /MenuItem> <
                        MenuItem value = { 9 } > 9 < /MenuItem> <
                        /Select> <
                        FormHelperText >
                        Price will be calculated based on distance and priority <
                        /FormHelperText> <
                        /FormControl> <
                        /Stack> <
                        /Grid> <
                        Grid item xs = { 6 } >
                        <
                        Button variant = "outlined" > Delete < /Button> <
                        /Grid> <
                        Grid item xs = { 6 } >
                        <
                        Stack direction = "row"
                        justifyContent = "end" >
                        <
                        Button variant = "contained"
                        onClick = { insertDB } >
                        Submit <
                        /Button> <
                        /Stack> <
                        /Grid> <
                        /Grid> <
                        /LocalizationProvider> <
                        /div>
                    );
                };
                export default PackageForm;