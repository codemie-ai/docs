import React from 'react';
import styles from './Applications.module.css';

type Tone = 'green' | 'blue' | 'purple' | 'amber';

const toneClass: Record<Tone, string> = {
  green: styles.toneGreen,
  blue: styles.toneBlue,
  purple: styles.tonePurple,
  amber: styles.toneAmber,
};

const cx = (...names: Array<string | false | undefined>): string => names.filter(Boolean).join(' ');

/* ---------- icons ---------- */

const icons: Record<string, React.ReactNode> = {
  tile: (
    <>
      <rect x="3" y="4" width="18" height="16" rx="2" />
      <path d="M3 9h18" />
    </>
  ),
  user: (
    <>
      <circle cx="12" cy="8" r="4" />
      <path d="M4 21c1-4.5 4-7 8-7s7 2.5 8 7" />
    </>
  ),
  model: (
    <>
      <path d="M12 3l8 4.5v9L12 21l-8-4.5v-9z" />
      <path d="M12 12v9M4 7.5l8 4.5 8-4.5" />
    </>
  ),
  code: <path d="M8 7l-5 5 5 5M16 7l5 5-5 5M14 4l-4 16" />,
  share: (
    <>
      <circle cx="6" cy="12" r="3" />
      <circle cx="18" cy="6" r="3" />
      <circle cx="18" cy="18" r="3" />
      <path d="M8.6 10.5l6.8-3M8.6 13.5l6.8 3" />
    </>
  ),
  server: (
    <>
      <rect x="3" y="4" width="18" height="6" rx="1.5" />
      <rect x="3" y="14" width="18" height="6" rx="1.5" />
      <path d="M7 7h.01M7 17h.01" />
    </>
  ),
  owner: (
    <>
      <circle cx="12" cy="8" r="4" />
      <path d="M12 14v7M8 18h8" />
    </>
  ),
  lock: (
    <>
      <rect x="5" y="10" width="14" height="10" rx="2" />
      <path d="M8 10V7a4 4 0 018 0v3" />
    </>
  ),
  shield: (
    <>
      <path d="M12 3l7 3v6c0 4.5-3 7.5-7 9-4-1.5-7-4.5-7-9V6z" />
      <path d="M9 12l2 2 4-4" />
    </>
  ),
  cycle: (
    <>
      <path d="M4 12a8 8 0 0114-5.3M20 12a8 8 0 01-14 5.3" />
      <path d="M18 3v4h-4M6 21v-4h4" />
    </>
  ),
  data: (
    <>
      <rect x="4" y="4" width="16" height="16" rx="2" />
      <path d="M9 9h6v6H9z" />
    </>
  ),
  pulse: <path d="M3 12h4l3-8 4 16 3-8h4" />,
};

function Icon({ name }: { name: string }): React.JSX.Element {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      {icons[name] ?? icons.tile}
    </svg>
  );
}

/* ---------- provides / expects ---------- */

interface SideItem {
  icon: string;
  title: string;
  text: string;
}

interface ProvidesCompareProps {
  provides: SideItem[];
  expects: SideItem[];
  providesTitle?: string;
  expectsTitle?: string;
}

export function ProvidesCompare({
  provides,
  expects,
  providesTitle = 'CodeMie provides',
  expectsTitle = 'Application team provides',
}: ProvidesCompareProps): React.JSX.Element {
  const side = (title: string, items: SideItem[], cls: string) => (
    <div className={cx(styles.card, styles.side, cls)}>
      <h4>{title}</h4>
      <div className={styles.items}>
        {items.map(it => (
          <div className={styles.item} key={it.title}>
            <Icon name={it.icon} />
            <div>
              <b>{it.title}</b>
              <span>{it.text}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
  return (
    <div className={cx(styles.root, styles.grid2)}>
      {side(providesTitle, provides, styles.sideBlue)}
      {side(expectsTitle, expects, styles.sideAmber)}
    </div>
  );
}

/* ---------- previews ---------- */

type Preview = 'link' | 'embedded' | 'hosted' | 'module';

function Wireframe({ kind, label }: { kind: Preview; label?: string }): React.JSX.Element {
  if (kind === 'link') {
    return (
      <div className={styles.wf}>
        <div className={cx(styles.win, styles.winCm)}>CodeMie</div>
        <div className={cx(styles.win, styles.winYou)}>
          application
          <br />
          new tab
        </div>
      </div>
    );
  }
  const title = label ?? (kind === 'hosted' ? 'codemie-host/your-app' : 'CodeMie');
  const inner =
    kind === 'module' ? (
      <div className={cx(styles.inner, styles.winCm, styles.innerDashed)}>
        application code
        <br />
        CodeMie origin
      </div>
    ) : (
      <div className={cx(styles.inner, styles.winYou)}>application</div>
    );
  return (
    <div className={styles.wf}>
      <div className={cx(styles.win, styles.winCm)}>
        {title}
        {inner}
      </div>
    </div>
  );
}

/* ---------- levels ---------- */

interface Level {
  n: number;
  title: string;
  preview: Preview;
  text: string;
  facts: Array<[string, string]>;
  effort: 1 | 2 | 3;
  highlight?: boolean;
}

export function LevelCards({ levels }: { levels: Level[] }): React.JSX.Element {
  return (
    <div className={cx(styles.root, styles.grid3)}>
      {levels.map(l => (
        <div
          key={l.n}
          className={cx(styles.card, styles.level, l.highlight && styles.levelHighlight)}
        >
          <div className={styles.levelHead}>
            <span className={styles.num}>{l.n}</span>
            <p className={styles.cardTitle}>{l.title}</p>
          </div>
          <Wireframe kind={l.preview} />
          <p className={styles.muted}>{l.text}</p>
          <dl className={styles.kv}>
            {l.facts.map(([k, v]) => (
              <React.Fragment key={k}>
                <dt>{k}</dt>
                <dd>{v}</dd>
              </React.Fragment>
            ))}
            <dt>Effort</dt>
            <dd>
              <span className={styles.meter} aria-label={`Effort ${l.effort} of 3`}>
                {[1, 2, 3].map(i => (
                  <i key={i} className={i <= l.effort ? styles.on : undefined} />
                ))}
              </span>
            </dd>
          </dl>
        </div>
      ))}
    </div>
  );
}

/* ---------- tile types ---------- */

interface TileType {
  name: string;
  preview: Preview;
  label?: string;
  caption: string;
}

export function TileTypeCards({ types }: { types: TileType[] }): React.JSX.Element {
  return (
    <div className={cx(styles.root, styles.grid3)}>
      {types.map(t => (
        <div key={t.name} className={styles.card}>
          <Wireframe kind={t.preview} label={t.label} />
          <p className={styles.cardTitle}>
            <code>{t.name}</code>
          </p>
          <p className={styles.muted}>{t.caption}</p>
        </div>
      ))}
    </div>
  );
}

/* ---------- scan strip ---------- */

export function ScanStrip({
  items,
}: {
  items: Array<{ title: string; text: string }>;
}): React.JSX.Element {
  return (
    <div className={cx(styles.root, styles.strip)}>
      {items.map(it => (
        <div key={it.title}>
          <b>{it.title}</b>
          <span>{it.text}</span>
        </div>
      ))}
    </div>
  );
}

/* ---------- tiers ---------- */

interface Tier {
  title: string;
  levels: number[];
  items: string[];
  highlight?: boolean;
}

export function TierCards({ tiers }: { tiers: Tier[] }): React.JSX.Element {
  return (
    <div className={cx(styles.root, styles.tiers)}>
      {tiers.map(t => (
        <div
          key={t.title}
          className={cx(styles.card, styles.tier, t.highlight && styles.tierHighlight)}
        >
          <div>
            <p className={styles.cardTitle}>{t.title}</p>
            <div className={styles.chips}>
              {t.levels.map(l => (
                <span key={l} className={styles.chip}>
                  {l}
                </span>
              ))}
            </div>
          </div>
          <ul className={styles.list}>
            {t.items.map(i => (
              <li key={i}>{i}</li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
}

/* ---------- do / don't ---------- */

export function DoAvoid({ dos, avoid }: { dos: string[]; avoid: string[] }): React.JSX.Element {
  return (
    <div className={cx(styles.root, styles.grid2)}>
      <div className={cx(styles.card, styles.do)}>
        <h4>Do</h4>
        <ul className={styles.list}>
          {dos.map(d => (
            <li key={d}>{d}</li>
          ))}
        </ul>
      </div>
      <div className={cx(styles.card, styles.avoid)}>
        <h4>Don&apos;t</h4>
        <ul className={styles.list}>
          {avoid.map(d => (
            <li key={d}>{d}</li>
          ))}
        </ul>
      </div>
    </div>
  );
}

/* ---------- steps ---------- */

interface Step {
  title: string;
  text: string;
  who?: string;
  highlight?: boolean;
}

export function StepCards({ steps }: { steps: Step[] }): React.JSX.Element {
  return (
    <ol className={cx(styles.root, styles.steps)}>
      {steps.map((s, i) => (
        <li
          key={s.title}
          className={cx(styles.card, styles.step, s.highlight && styles.stepHighlight)}
        >
          <span className={styles.stepN}>{String(i + 1).padStart(2, '0')}</span>
          <b>{s.title}</b>
          <p>{s.text}</p>
          {s.who && <span className={styles.who}>{s.who}</span>}
        </li>
      ))}
    </ol>
  );
}

/* ---------- hosting options ---------- */

type NodeKind = 'cm' | 'you' | 'gate' | 'neutral';

const nodeClass: Record<NodeKind, string> = {
  cm: styles.nodeCm,
  you: styles.nodeYou,
  gate: styles.nodeGate,
  neutral: styles.nodeNeutral,
};

interface FlowNode {
  title: string;
  sub?: string;
  kind: NodeKind;
}

interface Option {
  tag: string;
  tone: Tone;
  title: string;
  from: FlowNode;
  to: FlowNode;
  via?: string;
  text: string;
  preferred?: boolean;
}

function Node({ node }: { node: FlowNode }): React.JSX.Element {
  return (
    <div className={cx(styles.node, nodeClass[node.kind])}>
      <b>{node.title}</b>
      {node.sub && <span>{node.sub}</span>}
    </div>
  );
}

export function OptionCards({ options }: { options: Option[] }): React.JSX.Element {
  return (
    <div className={cx(styles.root, styles.grid3)}>
      {options.map(o => (
        <div
          key={o.title}
          className={cx(styles.card, styles.option, o.preferred && styles.optionPreferred)}
        >
          <div>
            <span className={cx(styles.tag, toneClass[o.tone])}>{o.tag}</span>
            <p className={styles.cardTitle}>{o.title}</p>
          </div>
          <div className={styles.mini}>
            <Node node={o.from} />
            <div className={styles.down}>{o.via && <span>{o.via}</span>}</div>
            <Node node={o.to} />
          </div>
          <p className={styles.muted}>{o.text}</p>
        </div>
      ))}
    </div>
  );
}

/* ---------- horizontal flow ---------- */

export function FlowRow({ nodes }: { nodes: FlowNode[] }): React.JSX.Element {
  return (
    <div className={cx(styles.root, styles.flow)}>
      {nodes.map((n, i) => (
        <React.Fragment key={n.title}>
          {i > 0 && (
            <div className={styles.arrow} aria-hidden="true">
              →
            </div>
          )}
          <Node node={n} />
        </React.Fragment>
      ))}
    </div>
  );
}
