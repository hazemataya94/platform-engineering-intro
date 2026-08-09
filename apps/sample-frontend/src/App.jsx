export default function App() {
  return (
    <main className="page">
      <p className="eyebrow">Platform Engineering Session</p>
      <h1>Sample Frontend</h1>
      <p className="lede">
        This React app is deployed through the frontend golden-path Helm chart.
      </p>
      <p className="note">
        It exists to show that different workload types can share platform defaults
        without every team redesigning deployment from scratch.
      </p>
    </main>
  );
}
