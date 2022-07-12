-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_item_auditor ( nr_seq_audiotira_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

			
nr_seq_item_w			bigint;
ds_retonrno_w			varchar(1) := 'N';
qt_item_w			integer;
nr_seq_guia_w			bigint;
nr_seq_requisicao_w		bigint;
nr_seq_execucao_w		bigint;
qt_ocorrencia_w			bigint;
ie_auditor_master_w		varchar(1);


BEGIN

select	nr_seq_guia,
	nr_seq_requisicao,
	nr_seq_execucao
into STRICT	nr_seq_guia_w,
	nr_seq_requisicao_w,
	nr_seq_execucao_w
from	pls_auditoria
where	nr_sequencia = nr_seq_audiotira_p;

ie_auditor_master_w := pls_obter_se_usuario_master(nm_usuario_p,null);

if (ie_auditor_master_w = 'S') then
	qt_item_w := 1;
	
else
	if (coalesce(nr_seq_guia_w,0) > 0) then

		select	count(nr_sequencia)
		into STRICT	qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_guia_plano = nr_seq_guia_w
		and ((nr_seq_proc IS NOT NULL AND nr_seq_proc::text <> '')
		or	(nr_seq_mat IS NOT NULL AND nr_seq_mat::text <> ''));

		if (qt_ocorrencia_w > 0) then
			if (ie_tipo_item_p = 'P') then
				select	count(*)
				into STRICT	qt_item_w
				from	pls_ocorrencia_benef e,
					pls_ocorrencia d,
					pls_ocorrencia_grupo c,
					pls_grupo_auditor b,
					pls_membro_grupo_aud a
				where	e.nr_seq_proc =  nr_seq_item_p
				and	e.nr_seq_guia_plano = nr_seq_guia_w
				and	e.nr_seq_ocorrencia = d.nr_sequencia
				and	d.nr_sequencia = c.nr_seq_ocorrencia
				and	c.nr_seq_grupo = b.nr_sequencia
				and	b.nr_sequencia = a.nr_seq_grupo
				and	upper(a.nm_usuario_exec) = upper(nm_usuario_p)
				and	a.ie_situacao = 'A'
				and	c.ie_situacao = 'A'
				and	b.ie_situacao = 'A';
			elsif (ie_tipo_item_p = 'M') then
				select	count(*)
				into STRICT	qt_item_w
				from	pls_ocorrencia_benef e,
					pls_ocorrencia d,
					pls_ocorrencia_grupo c,
					pls_grupo_auditor b,
					pls_membro_grupo_aud a
				where	e.nr_seq_mat =  nr_seq_item_p
				and	e.nr_seq_guia_plano = nr_seq_guia_w
				and	e.nr_seq_ocorrencia = d.nr_sequencia
				and	d.nr_sequencia = c.nr_seq_ocorrencia
				and	c.nr_seq_grupo = b.nr_sequencia
				and	b.nr_sequencia = a.nr_seq_grupo
				and	upper(a.nm_usuario_exec) = upper(nm_usuario_p)
				and	a.ie_situacao = 'A'
				and	c.ie_situacao = 'A'
				and	b.ie_situacao = 'A';
			end if;
		else
			qt_item_w := 1;
		end if;
	elsif (coalesce(nr_seq_requisicao_w,0) > 0) then

		select	count(nr_sequencia)
		into STRICT	qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_requisicao = nr_seq_requisicao_w
		and ((nr_seq_proc IS NOT NULL AND nr_seq_proc::text <> '')
		or	(nr_seq_mat IS NOT NULL AND nr_seq_mat::text <> ''));
		
		if (qt_ocorrencia_w > 0) then
			if (ie_tipo_item_p = 'P') then
				select	count(*)
				into STRICT	qt_item_w
				from	pls_ocorrencia_benef e,
					pls_ocorrencia d,
					pls_ocorrencia_grupo c,
					pls_grupo_auditor b,
					pls_membro_grupo_aud a
				where	e.nr_seq_proc =  nr_seq_item_p
				and	e.nr_seq_requisicao = nr_seq_requisicao_w
				and	e.nr_seq_ocorrencia = d.nr_sequencia
				and	d.nr_sequencia = c.nr_seq_ocorrencia
				and	c.nr_seq_grupo = b.nr_sequencia
				and	b.nr_sequencia = a.nr_seq_grupo
				and	upper(a.nm_usuario_exec) = upper(nm_usuario_p)
				and	a.ie_situacao = 'A'
				and	c.ie_situacao = 'A'
				and	b.ie_situacao = 'A';
			elsif (ie_tipo_item_p = 'M') then
				select	count(*)
				into STRICT	qt_item_w
				from	pls_ocorrencia_benef e,
					pls_ocorrencia d,
					pls_ocorrencia_grupo c,
					pls_grupo_auditor b,
					pls_membro_grupo_aud a
				where	e.nr_seq_mat =  nr_seq_item_p
				and	e.nr_seq_requisicao = nr_seq_requisicao_w
				and	e.nr_seq_ocorrencia = d.nr_sequencia
				and	d.nr_sequencia = c.nr_seq_ocorrencia
				and	c.nr_seq_grupo = b.nr_sequencia
				and	b.nr_sequencia = a.nr_seq_grupo
				and	upper(a.nm_usuario_exec) = upper(nm_usuario_p)
				and	a.ie_situacao = 'A'
				and	c.ie_situacao = 'A'
				and	b.ie_situacao = 'A';
			end if;
		else
			qt_item_w := 1;
		end if;
	elsif (coalesce(nr_seq_execucao_w,0) > 0) then

		select	count(nr_sequencia)
		into STRICT	qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_execucao = nr_seq_execucao_w
		and ((nr_seq_proc IS NOT NULL AND nr_seq_proc::text <> '')
		or	(nr_seq_mat IS NOT NULL AND nr_seq_mat::text <> ''));
		
		if (qt_ocorrencia_w > 0) then	
			if (ie_tipo_item_p = 'P') then
				select	count(*)
				into STRICT	qt_item_w
				from	pls_ocorrencia_benef e,
					pls_ocorrencia d,
					pls_ocorrencia_grupo c,
					pls_grupo_auditor b,
					pls_membro_grupo_aud a
				where	e.nr_seq_proc =  nr_seq_item_p
				and	e.nr_seq_execucao = nr_seq_execucao_w
				and	e.nr_seq_ocorrencia = d.nr_sequencia
				and	d.nr_sequencia = c.nr_seq_ocorrencia
				and	c.nr_seq_grupo = b.nr_sequencia
				and	b.nr_sequencia = a.nr_seq_grupo
				and	upper(a.nm_usuario_exec) = upper(nm_usuario_p)
				and	a.ie_situacao = 'A'
				and	c.ie_situacao = 'A'
				and	b.ie_situacao = 'A';
			elsif (ie_tipo_item_p = 'M') then
				select	count(*)
				into STRICT	qt_item_w
				from	pls_ocorrencia_benef e,
					pls_ocorrencia d,
					pls_ocorrencia_grupo c,
					pls_grupo_auditor b,
					pls_membro_grupo_aud a
				where	e.nr_seq_mat =  nr_seq_item_p
				and	e.nr_seq_execucao = nr_seq_execucao_w
				and	e.nr_seq_ocorrencia = d.nr_sequencia
				and	d.nr_sequencia = c.nr_seq_ocorrencia
				and	c.nr_seq_grupo = b.nr_sequencia
				and	b.nr_sequencia = a.nr_seq_grupo
				and	upper(a.nm_usuario_exec) = upper(nm_usuario_p)
				and	a.ie_situacao = 'A'
				and	c.ie_situacao = 'A'
				and	b.ie_situacao = 'A';
			end if;
		else
			qt_item_w := 1;
		end if;
	end if;
end if;

if (qt_item_w > 0) then
	ds_retonrno_w := 'S';
end if;

return	ds_retonrno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_item_auditor ( nr_seq_audiotira_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, nm_usuario_p text) FROM PUBLIC;
