-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_de_para_aut_intercam ( nr_seq_guia_proc_p bigint, nr_seq_guia_mat_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 
Gerar o de/para dos procedimentos e materiais quando a guia for de intercambio na hora de inseri-los na guia.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_procedimento_w		bigint;
cd_procedimento_ptu_w		bigint;
cd_material_ops_w		varchar(255);
cd_material_ops_aut_w		varchar(255);
cd_material_ptu_w		varchar(255);
cd_material_w			bigint;
cd_procedimento_ptu_aut_w	bigint;
cd_material_ptu_aut_w	        bigint;
ds_procedimento_ptu_w		varchar(80);
ds_procedimento_ptu_aut_w	varchar(80);
ds_material_ptu_w		varchar(80);
ds_material_ptu_aut_w		varchar(80);
ie_origem_proced_w		bigint;
ie_origem_proced_ptu_w		bigint;
ie_tipo_despesa_w		bigint;
ie_tipo_tabela_w		varchar(255);
nr_seq_guia_w			bigint;
nr_seq_prestador_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_congenere_w		bigint;
nr_seq_material_w		bigint;
nr_seq_regra_w			bigint;
ie_somente_codigo_w		pls_conversao_proc.ie_somente_codigo%type;
sg_estado_w			pessoa_juridica.sg_estado%type;
sg_estado_operadora_w		pessoa_juridica.sg_estado%type;
ie_tipo_processo_w		varchar(1);
ie_tipo_intercambio_w		varchar(1);
ie_utiliza_opme_ptu_w		pls_param_autorizacao.ie_utiliza_opme_ptu%type;	
ie_tipo_tabela_scs_w		pls_conversao_proc.ie_tipo_tabela_scs%type;
ie_servico_proprio_w		varchar(1);


BEGIN

begin
	select	coalesce(ie_utiliza_opme_ptu, 'N')
	into STRICT	ie_utiliza_opme_ptu_w
	from	pls_param_autorizacao;
exception
when others then
	ie_utiliza_opme_ptu_w	:= 'N';
end;

if (nr_seq_guia_proc_p IS NOT NULL AND nr_seq_guia_proc_p::text <> '') then
	begin
		select	cd_procedimento,
			ie_origem_proced,
			nr_seq_guia,
			cd_procedimento_ptu,
			substr(ds_procedimento_ptu,1,255)
		into STRICT	cd_procedimento_w,
			ie_origem_proced_w,
			nr_seq_guia_w,
			cd_procedimento_ptu_aut_w,
			ds_procedimento_ptu_aut_w
		from	pls_guia_plano_proc
		where	nr_sequencia	= nr_seq_guia_proc_p;
	exception
	when others then
		cd_procedimento_w	:= null;
		ie_origem_proced_w	:= null;
		nr_seq_guia_w	:= null;
	end;

	begin
		select	nr_seq_prestador,
			nr_seq_segurado,
			ie_tipo_processo
		into STRICT	nr_seq_prestador_w,
			nr_seq_segurado_w,
			ie_tipo_processo_w
		from	pls_guia_plano
		where	nr_sequencia	= nr_seq_guia_w;
	exception
	when others then
		nr_seq_prestador_w	:= null;
		nr_seq_segurado_w	:= null;
	end;

	begin
		select	nr_seq_congenere
		into STRICT	nr_seq_congenere_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
	exception
	when others then
		nr_seq_congenere_w	:= null;
	end;

	-- Obter a UF da operadora  - Tasy
	begin
		select	sg_estado
		into STRICT	sg_estado_w
		from	pessoa_juridica
		where	cd_cgc	=	(SELECT	cd_cgc_outorgante
					from	pls_outorgante
					where	cd_estabelecimento	= cd_estabelecimento_p);
	exception
	when others then
		sg_estado_w	:= 'X';
	end;

	-- Obter estado da operadora executora
	begin
		select	sg_estado
		into STRICT	sg_estado_operadora_w
		from	pls_congenere	a,
			pessoa_juridica	b
		where	b.cd_cgc	= a.cd_cgc
		and	a.nr_sequencia	= nr_seq_congenere_w;
	exception
	when others then
		sg_estado_operadora_w	:= 'X';
	end;

	if (coalesce(sg_estado_w, 'X') <> 'X') and (coalesce(sg_estado_operadora_w, 'X') <> 'X') and (coalesce(ie_tipo_processo_w, 'X') = 'I')	then
		if (sg_estado_w = sg_estado_operadora_w) then
			ie_tipo_intercambio_w	:= 'E';
		else
			ie_tipo_intercambio_w	:= 'N';
		end if;
	else
		ie_tipo_intercambio_w	:= 'A';
	end if;	

	SELECT * FROM pls_obter_proced_conversao(	cd_procedimento_w, ie_origem_proced_w, nr_seq_prestador_w, cd_estabelecimento_p, 3, nr_seq_congenere_w, 1, 'E', null, null, null, null, ie_tipo_intercambio_w, cd_procedimento_ptu_w, ie_origem_proced_ptu_w, nr_seq_regra_w, ie_somente_codigo_w, clock_timestamp(), null, null, null) INTO STRICT cd_procedimento_ptu_w, ie_origem_proced_ptu_w, nr_seq_regra_w, ie_somente_codigo_w;
	
	if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
		begin
			select	ie_tipo_tabela_scs,
				coalesce(ie_servico_proprio,'N')
			into STRICT	ie_tipo_tabela_scs_w,
				ie_servico_proprio_w
			from	pls_conversao_proc
			where	nr_sequencia	= nr_seq_regra_w;
		exception
		when others then
			ie_tipo_tabela_scs_w	:= null;
		end;		
	end if;

	if (cd_procedimento_ptu_w IS NOT NULL AND cd_procedimento_ptu_w::text <> '') then
		update	pls_guia_plano_proc
		set	cd_procedimento_ptu	= cd_procedimento_ptu_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			ie_tipo_tabela		= ie_tipo_tabela_scs_w,
			ie_servico_proprio	= ie_servico_proprio_w
		where	nr_sequencia		= nr_seq_guia_proc_p;
		
		ds_procedimento_ptu_w	:= substr(pls_obter_regra_desc_item_scs(cd_procedimento_ptu_w,'P',null,nr_seq_guia_w,nr_seq_guia_proc_p),1,80);

		if (ds_procedimento_ptu_w IS NOT NULL AND ds_procedimento_ptu_w::text <> '') and (coalesce(ds_procedimento_ptu_aut_w::text, '') = '') then
			update	pls_guia_plano_proc
			set	ds_procedimento_ptu	= substr(ds_procedimento_ptu_w,1,80),
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_sequencia		= nr_seq_guia_proc_p;
		end if;
	end if;
elsif (nr_seq_guia_mat_p IS NOT NULL AND nr_seq_guia_mat_p::text <> '') then
	begin
		select	nr_seq_material,
			nr_seq_guia,
			cd_material_ptu,
			substr(ds_material_ptu,1,80)
		into STRICT	nr_seq_material_w,
			nr_seq_guia_w,
			cd_material_ptu_aut_w,
			ds_material_ptu_aut_w
		from	pls_guia_plano_mat
		where	nr_sequencia	= nr_seq_guia_mat_p;
	exception
	when others then
		nr_seq_material_w	:= null;
	end;
	
	begin
		select	ie_tipo_despesa
		into STRICT	ie_tipo_despesa_w
		from	pls_material
		where	nr_sequencia	= nr_seq_material_w;
	exception
	when others then
		ie_tipo_despesa_w	:= null;
	end;
	
	if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
		cd_material_ops_w	:= substr(pls_obter_seq_codigo_material(nr_seq_material_w,''),1,8);
	end if;

	if (cd_material_ops_w IS NOT NULL AND cd_material_ops_w::text <> '') then
		if (ie_tipo_despesa_w	= 2) then
			ie_tipo_tabela_w	:= '3';
		elsif (ie_tipo_despesa_w	= 3) then
			ie_tipo_tabela_w	:= '2';
		else
			ie_tipo_tabela_w	:= '2';
		end if;
		
		SELECT * FROM ptu_gerar_mat_envio_intercamb(cd_material_ops_w, 'E', ie_tipo_tabela_w, ie_tipo_despesa_w, nm_usuario_p, cd_material_ptu_w, ds_material_ptu_w) INTO STRICT cd_material_ptu_w, ds_material_ptu_w;

		if (cd_material_ptu_w IS NOT NULL AND cd_material_ptu_w::text <> '') and (cd_material_ops_w	<> cd_material_ptu_w) then
			update	pls_guia_plano_mat
			set	cd_material_ptu		= cd_material_ptu_w,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_sequencia		= nr_seq_guia_mat_p;
		
			ds_material_ptu_w	:= substr(pls_obter_regra_desc_item_scs(cd_material_ptu_w,'M',null,nr_seq_guia_w,nr_seq_guia_mat_p),1,80);
			
			if (ds_material_ptu_w IS NOT NULL AND ds_material_ptu_w::text <> '') and (coalesce(ds_material_ptu_aut_w::text, '') = '') then
				update	pls_guia_plano_mat
				set	ds_material_ptu		= substr(ds_material_ptu_w,1,80),
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where	nr_sequencia		= nr_seq_guia_mat_p;
			end if;
		else
			if (cd_material_ops_w	<> cd_material_ptu_aut_w) then
				cd_material_ptu_aut_w	:= null;
				ds_material_ptu_aut_w	:= null;
			end if;
		
			if (coalesce(trim(both ds_material_ptu_aut_w)::text, '') = '') then
				--Verificar a regra "Regra descricao item SCS"  (sem o de/para)
				ds_material_ptu_w	:= substr(pls_obter_regra_desc_item_scs(cd_material_ops_w,'M',null,nr_seq_guia_w,nr_seq_guia_mat_p),1,80);
			else
				ds_material_ptu_w	:= ds_material_ptu_aut_w;
			end if;
			
			if (ds_material_ptu_w IS NOT NULL AND ds_material_ptu_w::text <> '') then
				update	pls_guia_plano_mat
				set	cd_material_ptu		= cd_material_ops_w,
					ds_material_ptu		= substr(ds_material_ptu_w,1,80),
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where	nr_sequencia		= nr_seq_guia_mat_p;
			elsif (ie_utiliza_opme_ptu_w = 'N') then			
				update	pls_guia_plano_mat
				set	cd_material_ptu		 = NULL,
					ds_material_ptu		 = NULL,
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where	nr_sequencia		= nr_seq_guia_mat_p;
			end if;
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_de_para_aut_intercam ( nr_seq_guia_proc_p bigint, nr_seq_guia_mat_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

