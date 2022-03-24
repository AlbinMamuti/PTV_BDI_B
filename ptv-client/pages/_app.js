import '../styles/globals.css'
import PackageForm from './PackageForm'
import Container from '@mui/material/Container'
import Typography from '@mui/material/Typography'


function MyApp({ Component, pageProps }) {
  
  return(
    <Container maxWidth="sm" >
      <Typography variant="h2">Delivery Service</Typography>
      <PackageForm/>
    </Container>
    
  )
}

export default MyApp
