import { useEffect, useState } from "react";
import AppMain from "./main";

export default function App() {

  const [mounted, setMounted] = useState<boolean>()

  useEffect(() => {
    setMounted(true)
  }, []);

  if (!mounted) {
    return (<></>);
  }

  return (<AppMain></AppMain>)
}
