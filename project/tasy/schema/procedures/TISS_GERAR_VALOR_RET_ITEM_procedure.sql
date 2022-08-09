-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_valor_ret_item ( nr_seq_item_dem_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_guia_prestador_p text) AS $body$
DECLARE


cd_procedimento_w		varchar(255);
cd_edicao_amb_w			varchar(255);
nr_seq_tiss_tabela_w		bigint;
ie_origem_valor_w		varchar(10);
vl_item_w			double precision;
ie_tipo_tabela_w		varchar(255);
ie_origem_proced_w		varchar(255);
ds_versao_w			varchar(255);


BEGIN

if (nr_seq_item_dem_p IS NOT NULL AND nr_seq_item_dem_p::text <> '') then

	select	max(cd_procedimento),
		max(ie_origem_proced),
		max(ie_tipo_tabela)
	into STRICT 	cd_procedimento_w,
		ie_origem_proced_w,
		ie_tipo_tabela_w
	from 	tiss_dem_conta_proc
	where 	nr_sequencia 		= nr_seq_item_dem_p;

	ds_versao_w	:= coalesce(TISS_OBTER_VERSAO(cd_convenio_p,cd_estabelecimento_p),'2.02.01');

	select 	max(nr_sequencia)
	into STRICT 	nr_seq_tiss_tabela_w
	from 	tiss_tipo_tabela
	where	cd_tabela_xml			= ie_tipo_tabela_w
	and 	coalesce(ie_versao_tiss,'2.02.01')	= ds_versao_w;

	select 	coalesce(max(ie_origem_valor),'A')
	into STRICT 	ie_origem_valor_w
	from 	tiss_regra_ret_valor
	where 	cd_estabelecimento 	= cd_estabelecimento_p
	and 	cd_convenio		= cd_convenio_p
	and 	nr_seq_tiss_tabela	= nr_seq_tiss_tabela_w;

	vl_item_w := 0;

	if (ie_origem_valor_w = 'PM') then

		select 	max(a.vl_procedimento)
		into STRICT 	vl_item_w
		from (SELECT	max(vl_procedimento) vl_procedimento
			from 	procedimento_paciente
			where	nr_interno_conta 		= (cd_guia_prestador_p)::numeric
			and (cd_procedimento		= cd_procedimento_w or
				cd_procedimento_convenio	= cd_procedimento_w or
				cd_procedimento_tuss		= cd_procedimento_w)
			and 	coalesce(cd_motivo_exc_conta::text, '') = ''
			
union

			SELECT 	max(vl_item) vl_procedimento
			from 	tiss_conta_desp
			where	nr_interno_conta 	= (cd_guia_prestador_p)::numeric 
			and	cd_procedimento		= lpad(trim(both cd_procedimento_w), 8, '0')
			and 	cd_edicao_amb	 	= ie_tipo_tabela_w) a;


		update	tiss_dem_conta_proc
		set 	vl_processado	= coalesce(vl_item_w,vl_processado),
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia	= nr_seq_item_dem_p;
		commit;

	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_valor_ret_item ( nr_seq_item_dem_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_guia_prestador_p text) FROM PUBLIC;
