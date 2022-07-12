-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION reg_fetch_revision_author ( nr_seq_revision_p bigint ) RETURNS varchar AS $body$
DECLARE


nm_author_user_w		reg_doc_revisor.nm_usuario_revisor%type;
nr_seq_documento_w		reg_version_revision.nr_seq_documento%type;


BEGIN

select	dr.nm_usuario_revisor
into STRICT	nm_author_user_w
from	reg_version_revision vr,
	reg_doc_revisor dr
where	vr.nr_sequencia = nr_seq_revision_p
and	vr.nr_seq_documento = dr.nr_seq_documento
and	dr.ie_tipo_revisor = 'C'
and	(
		(coalesce(dr.dt_fim_vigencia::text, '') = '' and vr.dt_atualizacao_nrec > dr.dt_inicio_vigencia) or (vr.dt_atualizacao_nrec between dr.dt_inicio_vigencia and fim_dia(dr.dt_fim_vigencia))
	);

return nm_author_user_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION reg_fetch_revision_author ( nr_seq_revision_p bigint ) FROM PUBLIC;

