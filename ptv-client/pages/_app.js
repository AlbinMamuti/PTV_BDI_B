import '../styles/globals.css'
import PackageForm from './PackageForm'
import Container from '@mui/material/Container'
import Typography from '@mui/material/Typography'
import AdapterDateFns from '@mui/lab/AdapterDateFns';
import LocalizationProvider from '@mui/lab/LocalizationProvider';

function MyApp({ Component, pageProps }) {
  
  return(
    <Container maxWidth="sm">
      <Typography variant="h2">Delivery Service</Typography>
      <PackageForm/>
    </Container>
    
  )
}

export default MyApp
