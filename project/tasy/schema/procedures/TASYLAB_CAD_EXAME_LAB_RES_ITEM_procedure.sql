-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasylab_cad_exame_lab_res_item ( nr_origem_p bigint, nr_seq_resultado_p bigint, nr_seq_exame_p text, qt_resultado_p text, ds_resultado_p text, nr_seq_metodo_p bigint, cd_material_integracao_p text, pr_resultado_p text, ie_status_p text, dt_aprovacao_p timestamp, nm_usuario_aprovacao_p text, nr_seq_prescr_p bigint, pr_minimo_p text, pr_maximo_p text, qt_minima_p text, qt_maxima_p text, ds_observacao_p text, ds_referencia_p text, ds_unidade_medida_p text, qt_decimais_p text, dt_coleta_p timestamp, dt_impressao_p timestamp, ie_consiste_p text, ie_normalidade_p text, ie_restringe_resultado_p text, dt_digitacao_p timestamp, nr_lote_reagente_p text, dt_validade_reagente_p timestamp, ds_resultado_curto_p text, nr_sequencia_p bigint, nm_medico_resp_p text, ds_hash_assinatura_p text, cd_erro_p INOUT bigint, ds_erro_p INOUT text ) AS $body$
DECLARE


cd_equipamento_w		equipamento_lab.cd_equipamento%type;

nr_seq_exame_w			exame_laboratorio.nr_seq_exame%type;

nr_seq_material_w		material_exame_lab.nr_sequencia%type;

nr_sequencia_w			exame_lab_result_item.nr_sequencia%type;

cd_medico_w				lab_tasylab_cliente.cd_medico%type;

nm_usuario_aprovacao_w	usuario.nm_usuario%type;

ds_resultado_w			varchar(4000);
ds_referencia_w			varchar(4000);
ds_observacao_w			varchar(4000);
quebra_w        		varchar(10) := chr(13)||chr(10);

nr_seq_formato_w		bigint;
nr_seq_metodo_w 		bigint;

qt_resultado_w				double precision; --varchar2(60);
pr_resultado_w				double precision; --varchar2(60);
pr_minimo_w					double precision; --varchar2(60);
pr_maximo_w					double precision; --varchar2(60);
qt_minima_w					double precision; --varchar2(60);
qt_maxima_w					double precision; --varchar2(60);
qt_decimais_w				varchar(60);


BEGIN

cd_erro_p	:= 0;

CALL tasy_atualizar_dados_sessao(nr_origem_p);

ds_resultado_w	:= replace(ds_resultado_p,'Ã£','ã');
ds_resultado_w	:= replace(ds_resultado_w,'Ã©','é');
ds_resultado_w	:= replace(ds_resultado_w,'Ãª','ê');

ds_referencia_w := replace(ds_referencia_p,'Ã£','ã');
ds_referencia_w := replace(ds_referencia_w,'Ã©','é');
ds_referencia_w := replace(ds_referencia_w,'Ãª','ê');

/*if (qt_resultado_p is not null) then
	qt_resultado_w	:= replace(qt_resultado_p, ',', '.');
end if;*/
qt_resultado_w := (qt_resultado_p)::numeric;

/*if (pr_resultado_p is not null) then
	pr_resultado_w	:= replace(pr_resultado_p, ',', '.');
end if;*/
pr_resultado_w := (pr_resultado_p)::numeric;

/*if (pr_minimo_p is not null) then
	pr_minimo_w	:= replace(pr_minimo_p, ',', '.');
end if;*/
pr_minimo_w    := (pr_minimo_p)::numeric;

/*if (pr_maximo_p is not null) then
	pr_maximo_w	:= replace(pr_maximo_p, ',', '.');
end if;*/
pr_maximo_w    := (pr_maximo_p)::numeric;

/*if (qt_minima_p is not null) then
	qt_minima_w	:= replace(qt_minima_p, ',', '.');
end if;*/
qt_minima_w    := (qt_minima_p)::numeric;

/*if (qt_maxima_p is not null) then
	qt_maxima_w	:= replace(qt_maxima_p, ',', '.');
end if;*/
qt_maxima_w    := (qt_maxima_p)::numeric;

if (qt_decimais_p IS NOT NULL AND qt_decimais_p::text <> '') then
	qt_decimais_w := replace(qt_decimais_p, ',', '.');
end if;

ds_referencia_w := replace(ds_referencia_w,'chr(13)',chr(13)||chr(10));

select	max(a.cd_equipamento)
into STRICT	cd_equipamento_w
from	equipamento_lab a
where	a.ds_sigla = 'TLAB';

select	max(a.nr_seq_exame)
into STRICT	nr_seq_exame_w
from	lab_exame_equip a
where	a.cd_equipamento = cd_equipamento_w
and		a.cd_exame_equip = nr_seq_exame_p;

if (coalesce(nr_seq_exame_w::text, '') = '') then
	cd_erro_p	:= 15;
end if;

select	max(a.nr_seq_material)
into STRICT	nr_seq_material_w
from	material_exame_lab_int a
where	a.cd_material_integracao = cd_material_integracao_p
and		a.cd_equipamento = cd_equipamento_w;

select	max(a.cd_medico)
into STRICT	cd_medico_w
from	lab_tasylab_cliente a
where	a.nr_seq_externo = nr_origem_p;

select	max(nm_usuario)
into STRICT	nm_usuario_aprovacao_w
from	usuario
where	cd_pessoa_fisica = cd_medico_w;

select	max(a.nr_seq_material),
		max(a.nr_seq_metodo),
		max(a.nr_sequencia)
into STRICT    nr_seq_material_w,
		nr_seq_metodo_w,
		nr_sequencia_w
from    exame_lab_result_item a
where   a.nr_seq_resultado = nr_seq_resultado_p
and		a.nr_seq_prescr = nr_seq_prescr_p
and		a.nr_seq_exame = nr_seq_exame_w;

select	max(Obter_Formato_Exame(nr_seq_exame_w, nr_seq_material_w, nr_seq_metodo_w, 'L'))
into STRICT	nr_seq_formato_w
;

ds_observacao_w	:=	substr('Aprovador externo: '||nm_medico_resp_p||quebra_w||ds_observacao_p,1,4000);

if (coalesce(nr_sequencia_w::text, '') = '') then
	begin

	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_sequencia_w
	from	exame_lab_result_item
	where	nr_seq_resultado = nr_seq_resultado_p;

	insert into exame_lab_result_item(
										nr_sequencia,
										nr_seq_resultado,
										nr_seq_exame,
										nr_seq_prescr,
										nr_seq_material,
										dt_atualizacao,
										nm_usuario,
										dt_aprovacao,
										--nm_usuario_aprovacao,
										--cd_medico_resp,
										ds_observacao,
										qt_resultado,
										ds_resultado,
										pr_resultado,
										pr_minimo,
										pr_maximo,
										qt_minima,
										qt_maxima,
										ds_referencia,
										ds_unidade_medida,
										qt_decimais,
										dt_digitacao,
										nr_seq_formato,
										ds_hash_assinatura
										)
							values (	nr_sequencia_w,
										nr_seq_resultado_p,
										nr_seq_exame_w,
										nr_seq_prescr_p,
										nr_seq_material_w,
										clock_timestamp(),
										'TASYLAB',
										dt_aprovacao_p,
										--nvl(nm_usuario_aprovacao_w, nm_usuario_aprovacao),
										--nvl(cd_medico_w, cd_medico_resp),
										ds_observacao_w,
										qt_resultado_w,
										ds_resultado_w,
										pr_resultado_w,
										pr_minimo_w,
										pr_maximo_w,
										qt_minima_w,
										qt_maxima_w,
										ds_referencia_w,
										ds_unidade_medida_p,
										qt_decimais_w,
										dt_digitacao_p,
										nr_seq_formato_w,
										ds_hash_assinatura_p
									);
	--OS727249 - Ivan
	--commit;
	exception
	when others then
		cd_erro_p	:= 1;
		ds_erro_p	:= substr('Erro ao inserir o item do resultado '||sqlerrm,1,2000);
	end;
else
	begin
	update	exame_lab_result_item
	set		nr_seq_material		= nr_seq_material_w,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario			= 'TASYLAB',
			dt_aprovacao		= dt_aprovacao_p,
			ds_observacao		= ds_observacao_w,
			qt_resultado		= qt_resultado_w,
			ds_resultado		= ds_resultado_w,
			pr_resultado		= pr_resultado_w,
			pr_minimo			= pr_minimo_w,
			pr_maximo			= pr_maximo_w,
			qt_minima			= qt_minima_w,
			qt_maxima			= qt_maxima_w,
			ds_referencia		= ds_referencia_w,
			ds_unidade_medida	= ds_unidade_medida_p,
			qt_decimais			= qt_decimais_w,
			dt_digitacao		= dt_digitacao_p,
			nr_seq_formato		= nr_seq_formato_w,
			ds_hash_assinatura             = ds_hash_assinatura_p
	where	nr_sequencia 		= nr_sequencia_w
	and		nr_seq_resultado = nr_seq_resultado_p;

	--OS727249 - Ivan
	--commit;
	exception
	when others then
		cd_erro_p	:= 1;
		ds_erro_p	:= substr('Erro ao atualizar o item do resultado '||sqlerrm,1,2000);
	end;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasylab_cad_exame_lab_res_item ( nr_origem_p bigint, nr_seq_resultado_p bigint, nr_seq_exame_p text, qt_resultado_p text, ds_resultado_p text, nr_seq_metodo_p bigint, cd_material_integracao_p text, pr_resultado_p text, ie_status_p text, dt_aprovacao_p timestamp, nm_usuario_aprovacao_p text, nr_seq_prescr_p bigint, pr_minimo_p text, pr_maximo_p text, qt_minima_p text, qt_maxima_p text, ds_observacao_p text, ds_referencia_p text, ds_unidade_medida_p text, qt_decimais_p text, dt_coleta_p timestamp, dt_impressao_p timestamp, ie_consiste_p text, ie_normalidade_p text, ie_restringe_resultado_p text, dt_digitacao_p timestamp, nr_lote_reagente_p text, dt_validade_reagente_p timestamp, ds_resultado_curto_p text, nr_sequencia_p bigint, nm_medico_resp_p text, ds_hash_assinatura_p text, cd_erro_p INOUT bigint, ds_erro_p INOUT text ) FROM PUBLIC;

