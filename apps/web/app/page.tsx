export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="z-10 max-w-5xl w-full items-center justify-center font-mono text-sm">
        <h1 className="text-4xl font-bold text-center mb-8">
          Welcome to DFWorX
        </h1>
        <p className="text-center text-muted-foreground mb-8">
          Your full-stack monorepo powered by Next.js and FastAPI
        </p>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-8">
          <div className="p-6 border rounded-lg">
            <h2 className="text-xl font-semibold mb-2">Frontend</h2>
            <ul className="space-y-1 text-sm text-muted-foreground">
              <li>Next.js 14</li>
              <li>React 18</li>
              <li>Tailwind CSS</li>
              <li>Shadcn UI</li>
            </ul>
          </div>

          <div className="p-6 border rounded-lg">
            <h2 className="text-xl font-semibold mb-2">Backend</h2>
            <ul className="space-y-1 text-sm text-muted-foreground">
              <li>FastAPI</li>
              <li>Python 3.12+</li>
              <li>Supabase</li>
              <li>ConvexDB</li>
            </ul>
          </div>
        </div>
      </div>
    </main>
  )
}
