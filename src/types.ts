export type AnyDataType = string | boolean | number | null | undefined

export interface BranchParams {
  '~channel'?: string
  '~feature'?: string
  '~tags'?: string[]
  '~campaign'?: string
  '~stage'?: string
  '~creation_source'?: string
  '~referring_link'?: string
  '~id'?: string
  '+referrer'?: string
  '+is_first_session': boolean
  '+clicked_branch_link': boolean
  '+non_branch_link'?: string
  '+url'?: string
  $canonical_url?: string
  $deeplink_path?: string
  [data: string]: AnyDataType | AnyDataType[] | Record<string, AnyDataType>
}

export interface BranchUniversalObject {
  canonicalIdentifier: string
  title?: string
  canonicalUrl?: string
  contentDescription?: string
  imageUrl?: string
  keywords?: string[]
}
export interface LinkProperties {
  alias?: string
  campaign?: string
  channel?: string
  feature?: string
  stage?: string
  tags?: string[]
  [param: string]: AnyDataType | AnyDataType[]
}
export interface BranchCallback {
  (result: { error: string | null; params: BranchParams | null }): void
}
