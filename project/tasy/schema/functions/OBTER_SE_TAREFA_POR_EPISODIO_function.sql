-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_tarefa_por_episodio ( nr_seq_episodio_p bigint, cd_categoria_p text, ie_tipo_diagnostico_p text default null, nr_seq_classif_diag_p bigint default null, cd_tipo_evolucao_p text default null, ie_escala_p text default null, nm_tabela_p text default null, ie_classif_diag_p text default null) RETURNS varchar AS $body$
DECLARE


ie_existe_tarefa_w	varchar(1) := 'N';


BEGIN
	-- Diagnóstico
	if (cd_categoria_p = 'DG') then
		select	(CASE WHEN (max(a.nr_sequencia) IS NOT NULL AND (max(a.nr_sequencia))::text <> '') THEN 'S' ELSE 'N' END)
		into STRICT	ie_existe_tarefa_w
		from	wl_worklist a,
				wl_item b
		where	a.nr_seq_episodio = nr_seq_episodio_p
		and		b.nr_sequencia = a.nr_seq_item
		and		b.cd_categoria = cd_categoria_p
		and		coalesce(a.ie_cancelado,'N') = 'N'
		and (a.ie_tipo_diagnostico = ie_tipo_diagnostico_p
		or		a.ie_classif_diag = ie_classif_diag_p);
		
	-- Notas clínicas
	elsif (cd_categoria_p = 'CN') then
		select	(CASE WHEN (max(a.nr_sequencia) IS NOT NULL AND (max(a.nr_sequencia))::text <> '') THEN 'S' ELSE 'N' END)
		into STRICT	ie_existe_tarefa_w
		from	wl_worklist a,
				wl_item b
		where	a.nr_seq_episodio = nr_seq_episodio_p
		and		b.nr_sequencia = a.nr_seq_item
		and		b.cd_categoria = cd_categoria_p
		and		coalesce(a.ie_cancelado,'N') = 'N'
		and		a.cd_tipo_evolucao = cd_tipo_evolucao_p;
	
	-- Estimativa de alta
	elsif (cd_categoria_p = 'ED') then
		select	(CASE WHEN (max(a.nr_sequencia) IS NOT NULL AND (max(a.nr_sequencia))::text <> '') THEN 'S' ELSE 'N' END)
		into STRICT	ie_existe_tarefa_w
		from	wl_worklist a,
				wl_item b
		where	a.nr_seq_episodio = nr_seq_episodio_p
		and		b.nr_sequencia = a.nr_seq_item
		and		b.cd_categoria = cd_categoria_p
		and		coalesce(a.ie_cancelado,'N') = 'N';
	
	-- Escalas e índices
	elsif (cd_categoria_p = 'S') then
		select	(CASE WHEN (max(a.nr_sequencia) IS NOT NULL AND (max(a.nr_sequencia))::text <> '') THEN 'S' ELSE 'N' END)
		into STRICT	ie_existe_tarefa_w
		from	wl_worklist a,
				wl_item b
		where	a.nr_seq_episodio = nr_seq_episodio_p
		and		b.nr_sequencia = a.nr_seq_item
		and		b.cd_categoria = cd_categoria_p
		and		coalesce(a.ie_cancelado,'N') = 'N'
		and		a.ie_escala = ie_escala_p
		and		a.nm_tabela_escala = nm_tabela_p;
	
	-- Carga de trabalho
	elsif (cd_categoria_p = 'WO') then
		select	(CASE WHEN (max(a.nr_sequencia) IS NOT NULL AND (max(a.nr_sequencia))::text <> '') THEN 'S' ELSE 'N' END)
		into STRICT	ie_existe_tarefa_w
		from	wl_worklist a,
				wl_item b
		where	a.nr_seq_episodio = nr_seq_episodio_p
		and		b.nr_sequencia = a.nr_seq_item
		and		b.cd_categoria = cd_categoria_p
		and		coalesce(a.ie_cancelado,'N') = 'N';

	end if;
	
	return ie_existe_tarefa_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_tarefa_por_episodio ( nr_seq_episodio_p bigint, cd_categoria_p text, ie_tipo_diagnostico_p text default null, nr_seq_classif_diag_p bigint default null, cd_tipo_evolucao_p text default null, ie_escala_p text default null, nm_tabela_p text default null, ie_classif_diag_p text default null) FROM PUBLIC;

