-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--procedure que ir? verificar se o grupo audito tem permiss?o para liberar ou n?o as ocorr?ncias vinculadas
CREATE OR REPLACE FUNCTION pls_cta_alt_valor_pck.pls_verifica_se_grupo_aud ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_v.nr_sequencia%type, nr_seq_grupo_atual_p pls_auditoria_conta_grupo.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_libera_w      varchar(1)  := 'S';
nr_nivel_liberacao_aud_w  pls_nivel_liberacao.nr_nivel_liberacao%type;
nr_nivel_liberacao_w    pls_nivel_liberacao.nr_nivel_liberacao%type;
nr_seq_nivel_lib_aud_w    pls_membro_grupo_aud.nr_sequencia%type;

BEGIN

if (nr_seq_grupo_atual_p IS NOT NULL AND nr_seq_grupo_atual_p::text <> '') then
  select  max(coalesce(a.nr_seq_nivel_lib, b.nr_seq_nivel_lib))
  into STRICT  nr_seq_nivel_lib_aud_w
  from  pls_membro_grupo_aud  a,
    pls_grupo_auditor  b
  where  a.nr_seq_grupo     = nr_seq_grupo_atual_p
  and  a.nm_usuario_exec   = nm_usuario_p
  and  a.nr_seq_grupo     = b.nr_sequencia;

  select  max(nr_nivel_liberacao)
  into STRICT  nr_nivel_liberacao_aud_w
  from  pls_nivel_liberacao
  where  nr_sequencia  = nr_seq_nivel_lib_aud_w;

  if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
    select  max(d.nr_nivel_liberacao)
    into STRICT  nr_nivel_liberacao_w
    FROM pls_conta_proc c, pls_ocorrencia_benef b, pls_ocorrencia a
LEFT OUTER JOIN tiss_motivo_glosa e ON (a.nr_seq_motivo_glosa = e.nr_sequencia)
LEFT OUTER JOIN pls_nivel_liberacao d ON (a.nr_seq_nivel_lib = d.nr_sequencia)
WHERE a.nr_sequencia    = b.nr_seq_ocorrencia and c.nr_sequencia    = b.nr_seq_conta_proc  and (coalesce(e.cd_motivo_tiss::text, '') = '' or e.cd_motivo_tiss not in ('1705','1706')) and c.nr_sequencia    = nr_seq_conta_proc_p  and b.ie_situacao  = 'A';
  elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then
    select  max(d.nr_nivel_liberacao)
    into STRICT  nr_nivel_liberacao_w
    FROM pls_conta_mat c, pls_ocorrencia_benef b, pls_ocorrencia a
LEFT OUTER JOIN tiss_motivo_glosa e ON (a.nr_seq_motivo_glosa = e.nr_sequencia)
LEFT OUTER JOIN pls_nivel_liberacao d ON (a.nr_seq_nivel_lib = d.nr_sequencia)
WHERE a.nr_sequencia    = b.nr_seq_ocorrencia and c.nr_sequencia    = b.nr_seq_conta_mat  and (coalesce(e.cd_motivo_tiss::text, '') = '' or e.cd_motivo_tiss not in ('1705','1706')) and c.nr_sequencia    = nr_seq_conta_mat_p  and b.ie_situacao    = 'A';
  end if;

  if (coalesce(nr_nivel_liberacao_w,0) <= coalesce(nr_nivel_liberacao_aud_w,0)) then
    ie_libera_w  := 'S';
  else
    ie_libera_w  := 'N';
  end if;
end if;

return ie_libera_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_cta_alt_valor_pck.pls_verifica_se_grupo_aud ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_v.nr_sequencia%type, nr_seq_grupo_atual_p pls_auditoria_conta_grupo.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) FROM PUBLIC;
