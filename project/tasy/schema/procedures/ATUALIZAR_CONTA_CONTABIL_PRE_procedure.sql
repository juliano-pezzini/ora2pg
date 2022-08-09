-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_conta_contabil_pre ( nr_interno_conta_p bigint, dt_mes_referencia_p timestamp, ie_atualiza_todos_p text) AS $body$
DECLARE


nr_interno_conta_w			bigint;
qt_reg				bigint;
cd_estabelecimento_w		smallint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_setor_atendimento_w		integer;
ie_classif_convenio_w		varchar(3);
cd_conta_contabil_w		varchar(40);
cd_centro_custo_w			bigint	:= 0;
nr_sequencia_w			bigint;
cd_material_w			bigint;
ie_tipo_atendimento_w		smallint;
ie_tipo_convenio_w			smallint;
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
ie_clinica_w			integer;
cd_local_estoque_w		smallint;
dt_mesano_referencia_w		timestamp;
nr_atendimento_w			bigint;
cd_plano_w			varchar(10);
ie_regra_pacote_ctb_w		varchar(1);
dt_material_w			timestamp;
dt_procedimento_w			timestamp;
dt_vigencia_w			timestamp;
ie_data_base_atual_conta_w		varchar(15);
ie_complexidade_sus_w		varchar(2);
ie_tipo_financ_sus_w		varchar(4);
cd_estab_logado_w		smallint;
ie_estabelecimento_conta_w		varchar(1);
ie_contab_rec_proc_aih_w		varchar(1);
nr_aih_w				bigint;
cd_proced_aih_unif_w		varchar(255);
cd_conta_contab_aih_w		varchar(20);
nr_seq_proc_interno_w	procedimento_paciente.nr_seq_proc_interno%type;
cd_sequencia_parametro_w	procedimento_paciente.cd_sequencia_parametro%type;
cd_sequencia_parametro_ww   procedimento_paciente.cd_sequencia_parametro%type;
/*Fabio em 12/03/2008
No cursor abaixo, alterei para buscar o estabelecimento da conta ao invez do atendimento.
Isto porque da problemas quando o atendimento eh de uma empresa e a conta de outra
EX:OS85313*/
c01 CURSOR FOR
SELECT	d.nr_atendimento,
	a.nr_interno_conta,
	b.nr_sequencia,
	a.cd_estabelecimento,
	b.cd_procedimento,
	b.ie_origem_proced,
	b.cd_setor_atendimento,
	c.ie_classif_contabil,
	c.ie_tipo_convenio,
	d.ie_tipo_atendimento,
	b.cd_convenio,
	b.cd_categoria,
	d.ie_clinica,
	substr(CASE WHEN coalesce(b.nr_seq_proc_pacote,0)=0 THEN 'N'  ELSE 'S' END ,1,1),
	b.dt_procedimento,
	b.nr_seq_proc_interno
from	conta_paciente a,
	procedimento_paciente b,
	convenio c,
	atendimento_paciente d
where 	a.nr_interno_conta	= nr_interno_conta_p
and	a.nr_interno_conta		= b.nr_interno_conta
and	a.cd_convenio_parametro	= c.cd_convenio
and	a.nr_atendimento		= d.nr_atendimento
and	((coalesce(b.cd_conta_contabil::text, '') = '') or (coalesce(ie_atualiza_todos_p,'N') = 'S'));

/*Fabio em 12/03/2008
No cursor abaixo, alterei para buscar o estabelecimento da conta ao invez do atendimento.
Isto porque da problemas quando o atendimento eh de uma empresa e a conta de outra
EX:OS85313*/
c02 CURSOR FOR
SELECT	d.nr_atendimento,
	a.nr_interno_conta,
	b.nr_sequencia,
	a.cd_estabelecimento,
	b.cd_material,
	b.cd_setor_atendimento,
	c.ie_classif_contabil,
	c.ie_tipo_convenio,
	d.ie_tipo_atendimento,
	b.cd_convenio,
	b.cd_categoria,
	d.ie_clinica,
	b.cd_local_estoque,
	substr(CASE WHEN coalesce(b.nr_seq_proc_pacote,0)=0 THEN 'N'  ELSE 'S' END ,1,1),
	b.dt_atendimento
from	conta_paciente a,
	material_atend_paciente b,
	convenio c,
	atendimento_paciente d
where	a.nr_interno_conta 	= nr_interno_conta_p
and	a.nr_interno_conta		= b.nr_interno_conta
and	a.cd_convenio_parametro	= c.cd_convenio
and	a.nr_atendimento		= d.nr_atendimento
and	((coalesce(b.cd_conta_contabil::text, '') = '') or (coalesce(ie_atualiza_todos_p,'N') = 'S'));


BEGIN

dt_mesano_referencia_w := dt_mes_referencia_p;

cd_estab_logado_w := wheb_usuario_pck.get_cd_estabelecimento;

select	coalesce(max(ie_estabelecimento_conta),'A'),
	coalesce(max(ie_contab_rec_proc_aih),'N')
into STRICT	ie_estabelecimento_conta_w,
	ie_contab_rec_proc_aih_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estab_logado_w;

begin
ie_data_base_atual_conta_w	:= substr(coalesce(obter_valor_param_usuario(85,151, obter_perfil_ativo, wheb_usuario_pck.GET_NM_USUARIO, wheb_usuario_pck.GET_CD_ESTABELECIMENTO),'MP'),1,15);
exception when others then
	ie_data_base_atual_conta_w	:= 'MP';
end;

dt_vigencia_w	:= dt_mesano_referencia_w;
	
OPEN C01;
LOOP
FETCH C01 into
	nr_atendimento_w,
	nr_interno_conta_w,
	nr_sequencia_w,
	cd_estabelecimento_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	cd_setor_atendimento_w,
	ie_classif_convenio_w,
	ie_tipo_convenio_w,
	ie_tipo_atendimento_w,
	cd_convenio_w,
	cd_categoria_w,
	ie_clinica_w,
	ie_regra_pacote_ctb_w,
	dt_procedimento_w,
	nr_seq_proc_interno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(cd_plano_convenio)
	into STRICT	cd_plano_w
	from	atend_categoria_convenio
	where	obter_atecaco_atendimento(nr_atendimento_w) = nr_seq_interno;
	
	cd_centro_custo_w	:= null;
	cd_sequencia_parametro_w := null;
	
	if (ie_data_base_atual_conta_w = 'IC') then
		dt_vigencia_w	:= dt_procedimento_w;
	end if;
	
	begin
	/*APAC*/

	ie_complexidade_sus_w	:= substr(sus_obter_dados_apac_conta(nr_interno_conta_w, 'CX','C'),1,2);
	ie_tipo_financ_sus_w	:= substr(sus_obter_dados_apac_conta(nr_interno_conta_w, 'TF','C'),1,4);
	/*AIH*/

	if (coalesce(ie_complexidade_sus_w::text, '') = '') and (coalesce(ie_tipo_financ_sus_w::text, '') = '') then
		ie_complexidade_sus_w	:= substr(sus_obter_complexidade_aih(nr_interno_conta_w),1,2);
		ie_tipo_financ_sus_w	:= substr(sus_obter_tipo_financ_aih(nr_interno_conta_w),1,4);
		
		select	max(ie_complexidade),
			max(ie_tipo_financiamento)
		into STRICT	ie_complexidade_sus_w,
			ie_tipo_financ_sus_w
		from	sus_aih_unif
		where	nr_interno_conta	= nr_interno_conta_w;
		
	end if;
	/*Demais procedimentos*/

	if (coalesce(ie_complexidade_sus_w::text, '') = '') and (coalesce(ie_tipo_financ_sus_w::text, '') = '') then
			select	ie_complexidade,
				ie_tipo_financiamento
			into STRICT	ie_complexidade_sus_w,
				ie_tipo_financ_sus_w
			from	sus_procedimento
			where	cd_procedimento		= cd_procedimento_w
			and	ie_origem_proced	= ie_origem_proced_w  LIMIT 1;
	end if;
	exception when others then
		ie_complexidade_sus_w	:= null;
		ie_tipo_financ_sus_w	:= null;
	end;
	
	SELECT * FROM Define_Conta_Procedimento(
		cd_estabelecimento_w, cd_procedimento_w, ie_origem_proced_w, 1, ie_clinica_w, cd_setor_atendimento_w, ie_classif_convenio_w, ie_tipo_atendimento_w, ie_tipo_convenio_w, cd_convenio_w, cd_categoria_w, dt_mesano_referencia_w, cd_conta_contabil_w, cd_centro_custo_w, cd_plano_w, ie_regra_pacote_ctb_w, ie_complexidade_sus_w, ie_tipo_financ_sus_w, null, null, null, null, null, nr_seq_proc_interno_w) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;		
		
		cd_sequencia_parametro_w := philips_contabil_pck.get_parametro_conta_contabil();
		
		if (ie_contab_rec_proc_aih_w = 'S') then
			nr_aih_w	:= sus_obter_aihunif_conta(nr_interno_conta_w);
		end if;
	
		if (ie_contab_rec_proc_aih_w = 'S') and (coalesce(nr_aih_w,0) <> 0) then
			begin
			cd_proced_aih_unif_w	:= sus_obter_proced_aih_unif(nr_interno_conta_w,2,'C');
			end;
		end if;
	
		if (ie_contab_rec_proc_aih_w = 'S') and (coalesce(nr_aih_w,0) <> 0) and (cd_procedimento_w = cd_proced_aih_unif_w) and (coalesce(cd_conta_contabil_w,'X') <> 'X') then
			begin
			cd_conta_contab_aih_w	:= cd_conta_contabil_w;
			end;
		end if;

	update	procedimento_paciente
	set	cd_conta_contabil		= cd_conta_contabil_w,
		cd_centro_custo_receita	= CASE WHEN cd_centro_custo_w=0 THEN null  ELSE cd_centro_custo_w END ,
		cd_sequencia_parametro  = cd_sequencia_parametro_w
	where	nr_sequencia 		= nr_sequencia_w;

	end;
end loop;
close c01;

if (ie_contab_rec_proc_aih_w = 'S') and (coalesce(cd_conta_contab_aih_w,'X') <> 'X') then
	begin
	update	procedimento_paciente
	set	cd_conta_contabil	= cd_conta_contab_aih_w,
	cd_sequencia_parametro  =  cd_sequencia_parametro_w
	where	nr_interno_conta	= nr_interno_conta_w
	and	((ie_atualiza_todos_p = 'N') or (coalesce(cd_conta_contabil::text, '') = ''));
	end;
end if;

commit;

cd_conta_contabil_w	:= null;
cd_centro_custo_w	:= 0;

open c02;
loop
fetch c02 into
	nr_atendimento_w,
	nr_interno_conta_w,
	nr_sequencia_w,
	cd_estabelecimento_w,
	cd_material_w,
	cd_setor_atendimento_w,
	ie_classif_convenio_w,
	ie_tipo_convenio_w,
	ie_tipo_atendimento_w,
	cd_convenio_w,
	cd_categoria_w,
	ie_clinica_w,
	cd_local_estoque_w,
	ie_regra_pacote_ctb_w,
	dt_material_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	qt_reg  := qt_reg + 1;
	cd_sequencia_parametro_ww := null;
	
	select	max(cd_plano_convenio)
	into STRICT	cd_plano_w
	from	atend_categoria_convenio
	where	obter_atecaco_atendimento(nr_atendimento_w) = nr_seq_interno;

	if (ie_data_base_atual_conta_w = 'IC') then
		dt_vigencia_w	:= dt_material_w;
	end if;
	
	SELECT * FROM Define_Conta_Material(
			cd_estabelecimento_w, cd_material_w, 1, ie_clinica_w, cd_setor_atendimento_w, ie_classif_convenio_w, ie_tipo_atendimento_w, ie_tipo_convenio_w, cd_convenio_w, cd_categoria_w, cd_local_estoque_w, null, dt_vigencia_w, cd_conta_contabil_w, cd_centro_custo_w, cd_plano_w, ie_regra_pacote_ctb_w) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
			
	cd_sequencia_parametro_ww := philips_contabil_pck.get_parametro_conta_contabil();

	update	material_atend_paciente
	set	cd_conta_contabil	= cd_conta_contabil_w,
	cd_sequencia_parametro  = cd_sequencia_parametro_ww
	where	nr_sequencia 	= nr_sequencia_w;

	end;
end loop;
close c02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_conta_contabil_pre ( nr_interno_conta_p bigint, dt_mes_referencia_p timestamp, ie_atualiza_todos_p text) FROM PUBLIC;
