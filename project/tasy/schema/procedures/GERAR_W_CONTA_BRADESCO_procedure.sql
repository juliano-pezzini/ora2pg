-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_conta_bradesco ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, ie_ordenacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_w		bigint;
nr_interno_conta_w		bigint;
cd_estabelecimento_w		smallint;
cd_convenio_w			integer;
ds_tipo_cirurgia_w		varchar(100);
ds_razao_social_w		pessoa_juridica.ds_razao_social%type;
cd_cgc_w			varchar(14);	
nm_segurado_w			varchar(60);
cd_usuario_convenio_w	varchar(30);
cd_senha_w			varchar(20);
ie_clinica_w			integer;
dt_entrada_w			timestamp;
dt_alta_w			timestamp;
cd_motivo_alta_w		smallint;
nr_sequencia_w		bigint;
cd_material_w			integer;
cd_grupo_material_w		smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w		integer;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_grupo_w			bigint;
cd_especialidade_w		bigint;
cd_area_w			bigint;
qt_item_w			double precision;
vl_item_w			double precision;
cd_setor_w			integer;
nr_seq_inf_w			bigint;
ds_informacao_w		varchar(90);
ie_diaria_w			varchar(1);
ie_existe_w			bigint;
ie_parto_normal_w		varchar(1);
ie_parto_cesaria_w		varchar(1);
ie_tipo_parto_w		varchar(1);
cd_doenca_w			varchar(10);
qt_nasc_morto_w		smallint;
qt_nasc_vivo_w		smallint;
qt_nasc_prematuro_w		smallint;
ds_motivo_alta_w		varchar(80);
ie_pacote_w			varchar(3);
NR_SEQ_PROC_PACOTE_w		bigint;
nr_seq_proc_w			bigint;
nr_seq_mat_w			bigint;
ie_gerar_w			varchar(1);
ie_proc_pacote_w		varchar(3);

c01 CURSOR FOR
	SELECT	a.nr_atendimento,
		a.nr_interno_conta,
		a.cd_estabelecimento,
		a.cd_convenio_parametro,
		substr(obter_valor_dominio(12,obter_tipo_atendimento(a.nr_atendimento)),1,100),
		substr(obter_cid_atendimento(a.nr_atendimento,'P'),1,10)
	from	atendimento_paciente b,
		conta_paciente a
	where	coalesce(a.nr_seq_protocolo,0) 	= CASE WHEN coalesce(nr_seq_protocolo_p,0)=0 THEN  coalesce(nr_seq_protocolo,0)  ELSE nr_seq_protocolo_p END
	and	coalesce(a.nr_interno_conta,0)	= CASE WHEN coalesce(nr_interno_conta_p,0)=0 THEN  coalesce(nr_interno_conta,0)  ELSE nr_interno_conta_p END 
	and	a.nr_atendimento		= b.nr_atendimento
	order	by 
		CASE WHEN ie_ordenacao_p=0 THEN  a.nr_atendimento END ,
		CASE WHEN ie_ordenacao_p=1 THEN  a.cd_autorizacao END ,
		CASE WHEN ie_ordenacao_p=2 THEN  somente_numero(a.cd_autorizacao) END ,
		CASE WHEN ie_ordenacao_p=3 THEN  obter_nome_pf_pj(b.cd_pessoa_fisica,null) END , 
		CASE WHEN ie_ordenacao_p=4 THEN  OBTER_MATRICULA_USUARIO(a.cd_convenio_parametro, a.nr_atendimento) END ,
		CASE WHEN ie_ordenacao_p=5 THEN  a.nr_seq_apresent END ,
		CASE WHEN ie_ordenacao_p=7 THEN  a.nr_interno_conta END ,
		CASE WHEN ie_ordenacao_p=6 THEN  0 END ,
		CASE WHEN ie_ordenacao_p=6 THEN  a.dt_periodo_inicial END , 
		a.nr_atendimento, 
		a.nr_interno_conta;

c02 CURSOR FOR
	SELECT	a.cd_material,
		a.cd_setor_atendimento,
		a.qt_material,
		a.vl_material,
		b.cd_grupo_material,
		b.cd_subgrupo_material,
		b.cd_classe_material,
		a.NR_SEQ_PROC_PACOTE,
		a.nr_sequencia
	from	estrutura_material_v b,
 		material_atend_paciente a
	where 	a.cd_material		= b.cd_material
	and	a.nr_interno_conta	= nr_interno_conta_w
	and 	coalesce(a.cd_motivo_exc_conta::text, '') = '';

c03 CURSOR FOR
	SELECT	a.cd_procedimento,
		a.ie_origem_proced,
		a.cd_setor_atendimento,
		a.qt_procedimento,
		a.vl_procedimento,
		b.cd_grupo_proc,
		b.cd_especialidade,
		b.cd_area_procedimento,
		a.NR_SEQ_PROC_PACOTE,
		a.nr_sequencia,
		CASE WHEN a.nr_seq_proc_pacote=a.nr_sequencia THEN 'P' WHEN coalesce(a.nr_seq_proc_pacote::text, '') = '' THEN 'F'  ELSE 'I' END  ie_proc_pacote
/*Anderson e Edgar -01/03/06 - OS 30324 - Incluimos tratamento para ver se o procedimento e o proprio pacote, se a regra e pacote, fora pacote ou item pacote */

	from	estrutura_procedimento_v b,						     
	 	procedimento_paciente a
	where 	a.cd_procedimento	= b.cd_procedimento
	and	a.ie_origem_proced	= b.ie_origem_proced
	and	a.nr_interno_conta	= nr_interno_conta_w
	and 	coalesce(a.cd_motivo_exc_conta::text, '') = '';

c04 CURSOR FOR
	SELECT	a.cd_informacao || ' - ' || a.ds_informacao,
		a.nr_seq_inf,
		a.ie_diaria,
		b.ie_pacote
	from	conv_regra_conta_mat b,
		convenio_regra_conta a
	where	a.nr_sequencia = b.nr_seq_regra
	and	coalesce(b.cd_material, cd_material_w)			= cd_material_w
	and	coalesce(b.cd_grupo_material, cd_grupo_material_w)	= cd_grupo_material_w
	and	coalesce(b.cd_subgrupo_material, cd_subgrupo_material_w)= cd_subgrupo_material_w
	and	coalesce(b.cd_classe_material, cd_classe_material_w)	= cd_classe_material_w
	and	coalesce(b.cd_setor_atendimento, cd_setor_w)		= cd_setor_w
	and	a.cd_convenio						= cd_convenio_w
	order by
		coalesce(cd_material, 0),
		coalesce(cd_grupo_material, 0),
		coalesce(cd_subgrupo_material, 0),
		coalesce(cd_classe_material, 0),
		coalesce(cd_setor_atendimento,0);

c05 CURSOR FOR
	SELECT	a.cd_informacao || ' - ' || a.ds_informacao,
		a.nr_seq_inf,
		a.ie_diaria,
		b.ie_pacote
	from	conv_regra_conta_proc b,
		convenio_regra_conta a
	where	a.nr_sequencia = b.nr_seq_regra
	and	coalesce(b.cd_procedimento,cd_procedimento_w)		= cd_procedimento_w
	and	((coalesce(b.cd_procedimento::text, '') = '') or (coalesce(b.ie_origem_proced,ie_origem_proced_w)	= ie_origem_proced_w))
	and	coalesce(b.cd_grupo_proced,cd_grupo_w)			= cd_grupo_w
	and	coalesce(b.cd_especial_proced, cd_especialidade_w)	= cd_especialidade_w
	and	coalesce(b.cd_area_proced, cd_area_w)			= cd_area_w
	and	coalesce(b.cd_setor_atendimento, cd_setor_w)		= cd_setor_w
	and	a.cd_convenio 					= cd_convenio_w
	and (b.ie_pacote						= ie_proc_pacote_w
		or b.ie_pacote = 'T')						   
/*Anderson e Edgar -01/03/06 - OS 30324 - Incluimos tratamento para ver se o procedimento e o proprio pacote, se a regra e pacote, fora pacote ou item pacote */

	order by
		coalesce(cd_procedimento, 0),
		coalesce(cd_grupo_proced, 0),
		coalesce(cd_especial_proced, 0),
		coalesce(cd_area_proced, 0),
		coalesce(cd_setor_atendimento, 0);


BEGIN

delete	FROM w_conta_bradesco
where	nm_usuario = nm_usuario_p;

commit;

open c01;
loop
	fetch c01 into	
			nr_atendimento_w,
			nr_interno_conta_w,
			cd_estabelecimento_w,
			cd_convenio_w,
			ds_tipo_cirurgia_w,
			cd_doenca_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	RAISE NOTICE '%', cd_estabelecimento_w;
	if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then
		select	b.ds_razao_social,
			a.cd_cgc
		into STRICT	ds_razao_social_w,
			cd_cgc_w
		from	estabelecimento a,
			pessoa_juridica b
		where	a.cd_cgc = b.cd_cgc
	        and	a.cd_estabelecimento = cd_estabelecimento_w;	
	end if;

	select	max(substr(obter_nome_pf(a.cd_pessoa_fisica),1,60)),
		max(b.cd_usuario_convenio),
		max(b.cd_senha),
		max(a.ie_clinica),
		max(a.dt_entrada),
		max(a.dt_alta),
		max(a.cd_motivo_alta)
	into STRICT	nm_segurado_w,
		cd_usuario_convenio_w,
		cd_senha_w,
		ie_clinica_w,
		dt_entrada_w,
		dt_alta_w,
		cd_motivo_alta_w
	from	atend_categoria_convenio b,
		atendimento_paciente a
	where	a.nr_atendimento	= b.nr_atendimento
	  and	b.cd_convenio		= cd_convenio_w
	  and	a.nr_atendimento	= nr_atendimento_w
	  and	b.dt_inicio_vigencia	= 	(SELECT	max(x.dt_inicio_vigencia)
						from	atend_categoria_convenio x
						where	nr_atendimento = nr_atendimento_w);

	if (cd_motivo_alta_w IS NOT NULL AND cd_motivo_alta_w::text <> '') then
		select	ds_motivo_alta
		into STRICT	ds_motivo_alta_w
		from	motivo_alta
		where	cd_motivo_alta = cd_motivo_alta_w;
	end if;

	select	coalesce(max(ie_parto_normal),'N'),
		coalesce(max(ie_parto_cesaria),'N')
	into STRICT	ie_parto_normal_w,
		ie_parto_cesaria_w
	from	parto
	where	nr_atendimento = nr_atendimento_w;
	if (ie_parto_normal_w = 'S') then
		ie_tipo_parto_w	:= 1;
	elsif (ie_parto_cesaria_w = 'S') then
		ie_tipo_parto_w	:= 2;
	end if;

	select	count(*)
	into STRICT	qt_nasc_vivo_w
	from	nascimento
	where	ie_unico_nasc_vivo = 'S'
	and	nr_atendimento = nr_atendimento_w;

	select	count(*)
	into STRICT	qt_nasc_morto_w
	from	nascimento
	where	ie_unico_nasc_vivo = 'N'
	and	nr_atendimento = nr_atendimento_w;

	qt_nasc_prematuro_w	:= 0;

	select	nextval('w_conta_bradesco_seq')
	into STRICT	nr_sequencia_w
	;

	select	coalesce(max(cd_procedimento),null)
	into STRICT	cd_procedimento_w
	from	procedimento_paciente
	where	nr_interno_conta = nr_interno_conta_w
	  and	ie_proc_princ_atend = 'S';

	/* Fabio, Segundo a Rosane HDH, somente podem aparecer no relatorio CID = Oficial*/

	select	coalesce(max(cd_doenca_w),'')
	into STRICT	cd_doenca_w
	from	cid_especialidade c,
	  	cid_categoria b,
	  	cid_doenca a
	where	a.cd_categoria_cid = b.cd_categoria_cid
	and	b.cd_especialidade = c.cd_especialidade_cid
	and	c.cd_especialidade_cid = '9999999999'
	and	a.cd_doenca_cid	= cd_doenca_w;

	insert into w_conta_bradesco(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		ds_razao_prestador,
		nr_cnes,
		nr_cnpj,
		nm_segurado,
		nr_cartao_segurado,
		ds_senha_internacao,
		dt_internacao,
		ie_tipo_clinica,
		ds_tipo_cirurgia,
		cd_procedimento,
		ie_tipo_parto,
		qt_nasc_vivo,
		qt_nasc_prematuro,
		qt_nasc_morto,
		ie_complicacoes_pue,
		cd_doenca,
		dt_alta,
		cd_motivo_alta,
		ds_motivo_alta,
		nr_interno_conta,
		nr_seq_protocolo)
	Values (	
		nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		ds_razao_social_w,
		null,
		cd_cgc_w,
		nm_segurado_w,
		cd_usuario_convenio_w,
		cd_senha_w,
		dt_entrada_w,
		ie_clinica_w,
		ds_tipo_cirurgia_w,
		cd_procedimento_w,
		ie_tipo_parto_w,
		qt_nasc_vivo_w,
		qt_nasc_prematuro_w,
		qt_nasc_morto_w,
		null,
		cd_doenca_w,
		dt_alta_w,
		cd_motivo_alta_w,
		ds_motivo_alta_w,
		nr_interno_conta_p,
		nr_seq_protocolo_p);

	open c02;
	loop
		fetch c02 into	
				cd_material_w,
				cd_setor_w,
				qt_item_w,
				vl_item_w,
				cd_grupo_material_w,
				cd_subgrupo_material_w,
				cd_classe_material_w,
				NR_SEQ_PROC_PACOTE_w,
				nr_seq_mat_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

		open c04;
		loop
			fetch c04 into
					ds_informacao_w,
					nr_seq_inf_w,
					ie_diaria_w,
					ie_pacote_w;
			EXIT WHEN NOT FOUND; /* apply on c04 */
		end loop;
		close c04;

		/* Inicio tratamento de pacote */

		ie_gerar_w		:= 'S';
		if (NR_SEQ_PROC_PACOTE_w IS NOT NULL AND NR_SEQ_PROC_PACOTE_w::text <> '') then
			if (ie_pacote_w = 'P') then
				ie_gerar_w		:= 'N';
			end if;
			if (ie_pacote_w = 'I')  then
				ie_gerar_w		:= 'S';
			end if;

		end if;
		if (ie_pacote_w = 'F') and (NR_SEQ_PROC_PACOTE_w IS NOT NULL AND NR_SEQ_PROC_PACOTE_w::text <> '') then
			ie_gerar_w		:= 'N';
		end if;
		/* Fim tratamento de pacote */

		select	count(*)
		into STRICT	ie_existe_w
		from 	w_conta_bradesco_item
		where	nr_seq_conta_bradesco	= nr_sequencia_w
		  and	nr_seq_item			= nr_seq_inf_w;

		if (ie_gerar_w = 'S') then
			if (ie_existe_w = 0) then
				insert into w_conta_bradesco_item(
					nr_seq_conta_bradesco,
					nr_seq_item,
					ds_item,
					qt_diaria,
					vl_item)
				values (
					nr_sequencia_w,
					nr_seq_inf_w,
					ds_informacao_w,
					CASE WHEN ie_diaria_w='S' THEN qt_item_w  ELSE null END ,
					vl_item_w);
			else
				update	w_conta_bradesco_item
				set	qt_diaria = CASE WHEN ie_diaria_w='S' THEN qt_diaria + qt_item_w  ELSE null END ,
					vl_item = coalesce(vl_item,0) + coalesce(vl_item_w,0)
				where	nr_seq_conta_bradesco	= nr_sequencia_w
				  and	nr_seq_item			= nr_seq_inf_w;
			end if;
		end if;
	end loop;
	close c02;

	open c03;
	loop
		fetch c03 into	
				cd_procedimento_w,
				ie_origem_proced_w,
				cd_setor_w,
				qt_item_w,
				vl_item_w,
				cd_grupo_w,
				cd_especialidade_w,
				cd_area_w,
				NR_SEQ_PROC_PACOTE_w,
				nr_seq_proc_w,
				ie_proc_pacote_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */

		open c05;
		loop
			fetch c05 into	
					ds_informacao_w,
					nr_seq_inf_w,
					ie_diaria_w,
					ie_pacote_w;
			EXIT WHEN NOT FOUND; /* apply on c05 */
		end loop;
		close c05;

		/* Inicio tratamento de pacote */

		ie_gerar_w		:= 'S';
		if (NR_SEQ_PROC_PACOTE_w IS NOT NULL AND NR_SEQ_PROC_PACOTE_w::text <> '') then

			if (ie_pacote_w = 'P') and (nr_seq_proc_w <> NR_SEQ_PROC_PACOTE_w) then
				ie_gerar_w		:= 'N';
			end if;

			if (ie_pacote_w = 'I') and (nr_seq_proc_w = NR_SEQ_PROC_PACOTE_w) then
				ie_gerar_w		:= 'N';
			end if;

		end if;
		if (ie_pacote_w = 'F') and (NR_SEQ_PROC_PACOTE_w IS NOT NULL AND NR_SEQ_PROC_PACOTE_w::text <> '') then
			ie_gerar_w		:= 'N';
		end if;
		/* Fim tratamento de pacote */

		select	count(*)
		into STRICT	ie_existe_w
		from 	w_conta_bradesco_item
		where	nr_seq_conta_bradesco	= nr_sequencia_w
		  and	nr_seq_item			= nr_seq_inf_w;

		if (ie_gerar_w = 'S') then
			if (ie_existe_w = 0) then
				insert into w_conta_bradesco_item(
					nr_seq_conta_bradesco,
					nr_seq_item,
					ds_item,
					qt_diaria,
					vl_item)
				values (
					nr_sequencia_w,
					nr_seq_inf_w,
					ds_informacao_w,
					CASE WHEN ie_diaria_w='S' THEN qt_item_w  ELSE null END ,
					vl_item_w);
			else
				update	w_conta_bradesco_item
				set	qt_diaria = CASE WHEN ie_diaria_w='S' THEN qt_diaria + qt_item_w  ELSE null END ,
					vl_item = coalesce(vl_item,0) + coalesce(vl_item_w,0)
				where	nr_seq_conta_bradesco	= nr_sequencia_w
				  and	nr_seq_item			= nr_seq_inf_w;
			end if;
		end if;
	end loop;
	close c03;

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_conta_bradesco ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, ie_ordenacao_p bigint, nm_usuario_p text) FROM PUBLIC;
