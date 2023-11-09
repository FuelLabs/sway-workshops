import './App.css';
import CreateCampaign from './components/CreateCampaign';

function App() {
  return (
    <div className="App">

      <div>Total Campaigns: 0</div>

      <CreateCampaign/>

      

    {/* get campaigns and map through them all - shouldn't need to connect wallet to see this */}


     
    </div>
  );
}

export default App;
