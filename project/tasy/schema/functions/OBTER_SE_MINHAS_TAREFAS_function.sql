-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_minhas_tarefas (nr_seq_worklist_p wl_worklist.nr_sequencia%type, nr_seq_item_p wl_item.nr_sequencia%type, nm_usuario_p wl_item.nm_usuario%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w  		varchar(1) := 'N';
cd_categoria_w		wl_item.cd_categoria%type;


BEGIN
	select	max(it.cd_categoria)
	into STRICT	cd_categoria_w
	from	wl_item it
	where	it.nr_sequencia = nr_seq_item_p
	and		it.ie_situacao = 'A';

	if (cd_categoria_w in ('RC', 'C', 'LFP', 'D')) then
		ds_retorno_w := 'S';
	end if;

	if ((cd_categoria_w IS NOT NULL AND cd_categoria_w::text <> '') and cd_categoria_w not in ('MT', 'RC', 'D')) then
		select	CASE WHEN coalesce(max(wo.nr_sequencia)::text, '') = '' THEN 'N'  ELSE 'S' END
		into STRICT	ds_retorno_w
		from	wl_worklist wo
		where	wo.nr_sequencia = nr_seq_worklist_p
		and		wo.cd_profissional = obter_pf_usuario(nm_usuario_p, 'C');
	end if;

		if (cd_categoria_w in ('RC', 'C', 'NS', 'VN', 'RA')) then
			ds_retorno_w := 'S';
		end if;

		if ((cd_categoria_w IS NOT NULL AND cd_categoria_w::text <> '') and cd_categoria_w not in ('MT', 'RC', 'NS', 'VN', 'RA')) then
			select	CASE WHEN coalesce(max(wo.nr_sequencia)::text, '') = '' THEN 'N'  ELSE 'S' END
			into STRICT	ds_retorno_w
			from	wl_worklist wo
			where	wo.nr_sequencia = nr_seq_worklist_p
			and		wo.cd_profissional = obter_pf_usuario(nm_usuario_p, 'C');
		end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_minhas_tarefas (nr_seq_worklist_p wl_worklist.nr_sequencia%type, nr_seq_item_p wl_item.nr_sequencia%type, nm_usuario_p wl_item.nm_usuario%type) FROM PUBLIC;
