-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_verificar_interacao_medic ( nr_seq_mat_cpoe_p bigint, nr_atendimento_p bigint, cd_material_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, cd_paciente_p text, ie_funcao_prescritor_p text, nm_usuario_p text, ds_orientacao_p INOUT text, ds_interacao_p INOUT text) AS $body$
DECLARE


ds_material_w            varchar(100);
ds_material_ww           varchar(100);
ds_severidade_w          varchar(254);
ds_interacao_w           varchar(4000) := '';
ds_principio_ativo_w     varchar(100);
exec_w                   varchar(4000);
ds_tipo_w                material_interacao_medic.ds_tipo%type;
nr_seq_ficha_tecnica_w   material_interacao_medic.nr_seq_ficha%type;
cd_material_interacao_w  material_interacao_medic.cd_material_interacao%type;
ie_severidade_w          material_interacao_medic.ie_severidade%type;
ds_orientacao_w          material_interacao_medic.ds_orientacao%type;
nr_dias_interacao_w      parametro_medico.nr_dias_interacao%type;
ds_parametros_w          varchar(4000);
ds_erro_w                varchar(4000);
c01 CURSOR FOR
SELECT	distinct substr(obter_desc_material(a.cd_material_interacao), 1, 100),
		a.ds_tipo,
		substr(obter_valor_dominio(1325, a.ie_severidade), 1, 254),
		ie_severidade,
		a.cd_material_interacao,
		a.ds_orientacao,
		substr(obter_desc_ficha_tecnica(a.nr_seq_ficha_interacao), 1, 100) ds_principio_ativo
from	material_interacao_medic  a,
		cpoe_material_vig_v       b
where	a.cd_material = cd_material_p
and 	a.cd_material = b.cd_material
and 	(a.cd_material IS NOT NULL AND a.cd_material::text <> '')
and 	b.nr_atendimento = nr_atendimento_p
and 	coalesce(a.cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
and 	coalesce(a.ie_funcao_prescritor, ie_funcao_prescritor_p) = ie_funcao_prescritor_p
and 	cpoe_consiste_severidade_apres(cd_perfil_p, nr_atendimento_p, a.ie_severidade) = 'S'
and 	exists (select	1
				from	medic_uso_continuo c
				where	c.cd_pessoa_fisica = cd_paciente_p	
				and 	c.cd_material = a.cd_material_interacao)
and   coalesce(a.ie_situacao, 'A') = 'A'

union

select	distinct substr(obter_desc_material(a.cd_material_interacao), 1, 100),
		a.ds_tipo,
		substr(obter_valor_dominio(1325, a.ie_severidade), 1, 254),
		ie_severidade,
		a.cd_material_interacao,
		a.ds_orientacao,
		substr(obter_desc_ficha_tecnica(a.nr_seq_ficha_interacao), 1, 100) ds_principio_ativo
from	material_interacao_medic  a,
		cpoe_material_vig_v       b
where	a.cd_material = cd_material_p
and 	a.cd_material_interacao = b.cd_material
and 	(a.cd_material IS NOT NULL AND a.cd_material::text <> '')
and 	b.nr_atendimento = nr_atendimento_p
and 	coalesce(a.cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
and 	coalesce(a.ie_funcao_prescritor, ie_funcao_prescritor_p) = ie_funcao_prescritor_p
and 	cpoe_consiste_severidade_apres(cd_perfil_p, nr_atendimento_p, a.ie_severidade) = 'S'
and   coalesce(a.ie_situacao, 'A') = 'A'

union
	
SELECT	distinct substr(x.ds_material, 1, 100),
		a.ds_tipo,
		substr(obter_valor_dominio(1325, a.ie_severidade), 1, 254),
		ie_severidade,
		b.cd_material,
		a.ds_orientacao,
		substr(obter_desc_ficha_tecnica(a.nr_seq_ficha_interacao), 1, 100) ds_principio_ativo
from	material                  x,
		material_interacao_medic  a,
		cpoe_material_vig_v       b
where	b.cd_material = x.cd_material
and 	a.nr_seq_ficha = x.nr_seq_ficha_tecnica
and 	b.nr_atendimento = nr_atendimento_p
and 	(a.nr_seq_ficha_interacao IS NOT NULL AND a.nr_seq_ficha_interacao::text <> '')
and 	a.nr_seq_ficha_interacao = nr_seq_ficha_tecnica_w
and 	coalesce(a.cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
and 	coalesce(a.ie_funcao_prescritor, ie_funcao_prescritor_p) = ie_funcao_prescritor_p
and 	cpoe_consiste_severidade_apres(cd_perfil_p, nr_atendimento_p, a.ie_severidade) = 'S'
and   coalesce(a.ie_situacao, 'A') = 'A';


BEGIN
    delete	FROM cpoe_interacao
    where	nr_seq_mat_cpoe = nr_seq_mat_cpoe_p
    and 	cd_material = cd_material_p
    and 	nr_atendimento = nr_atendimento_p;

    select	max(substr(c.ds_material, 1, 100)),
			max(c.nr_seq_ficha_tecnica)
    into STRICT	ds_material_w,	
			nr_seq_ficha_tecnica_w
    from	material c
    where	c.cd_material = cd_material_p;

    select	max(nr_dias_interacao)
    into STRICT 	nr_dias_interacao_w
    from	parametro_medico
    where	cd_estabelecimento = cd_estabelecimento_p;

    open c01;
    loop
	fetch c01 into
		ds_material_ww,
		ds_tipo_w,
		ds_severidade_w,
		ie_severidade_w,
		cd_material_interacao_w,
		ds_orientacao_w,
		ds_principio_ativo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
		insert into cpoe_interacao(
			nr_sequencia,
			nr_seq_mat_cpoe,
			nr_atendimento,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_material,
			cd_material_interacao,
			ds_interacao,
			ie_severidade,
			nr_seq_ficha_tecnica,
			cd_pessoa_fisica
		) values (
			nextval('cpoe_interacao_seq'),
			nr_seq_mat_cpoe_p,
			nr_atendimento_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_material_p,
			cd_material_interacao_w,
			ds_tipo_w,
			ie_severidade_w,
			nr_seq_ficha_tecnica_w,
			cd_paciente_p);

		begin
			exec_w := 'call obter_ds_inter_cpoe_medic_md(:1,:2,:3,:4,:5,:6) into :result';
			EXECUTE exec_w using in ds_interacao_w,
										   in ds_material_w, 
										   in ds_material_ww, 
										   in ds_tipo_w, 
										   in ds_severidade_w, 
										   in ds_principio_ativo_w,
										   out ds_interacao_w;

		exception
			when others then
				ds_erro_w := substr(sqlerrm, 1, 4000);
				ds_parametros_w := substr( 'nr_seq_mat_cpoe_p: '||nr_seq_mat_cpoe_p||'-nr_atendimento_p: '||nr_atendimento_p||'-cd_material_p: '||cd_material_p||'-cd_perfil_p: '||cd_perfil_p||
										   '-ie_funcao_prescritor_p: '||ie_funcao_prescritor_p||'-ds_interacao_w: '||ds_interacao_w||'-ds_material_w: '||ds_material_w||'-ds_material_ww: '||ds_material_ww||
										   '-ds_tipo_w: '||ds_tipo_w||'-ds_severidade_w: '||ds_severidade_w||'-ds_principio_ativo_w: '||ds_principio_ativo_w, 1, 4000);
				CALL gravar_log_medical_device('CPOE_VERIFICAR_INTERACAO_MEDIC', 'OBTER_DS_INTER_CPOE_MEDIC_MD', ds_parametros_w, substr(ds_erro_w, 4000), nm_usuario_p, 'S');
				ds_interacao_w := null;
		end;
	end;
    end loop;

    close c01;
    ds_orientacao_p := ds_orientacao_w;
    ds_interacao_p := ds_interacao_w;
    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_verificar_interacao_medic ( nr_seq_mat_cpoe_p bigint, nr_atendimento_p bigint, cd_material_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, cd_paciente_p text, ie_funcao_prescritor_p text, nm_usuario_p text, ds_orientacao_p INOUT text, ds_interacao_p INOUT text) FROM PUBLIC;
