-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hbh_atualiza_dt_revis_contrato ( cd_estabelecimento_p bigint) AS $body$
DECLARE


--Parâmetro do cursor c01
nr_sequencia_w			bigint;
cd_setor_w				bigint;
ds_setor_w				varchar(10);
qt_dias_revisao_w		smallint;
dt_revisao_w			timestamp;
nm_usuario_w			varchar(15);
linha					bigint;
nm_usuario_dest_w		varchar(4000) := '';
ds_objeto_contrato_w	varchar(2000);
nm_contratado_w			varchar(255);
ds_tipo_contrato_w		varchar(255);
dt_fim_w				timestamp;
dt_inicio_w				timestamp;
qt_dias_vencer_w		integer;
ds_forma_renovacao_w	varchar(255);
vl_total_contrato_w		double precision;
ds_condicao_pagamento_w	varchar(80);
ds_forma_pagamento_w	varchar(255);
ds_moeda_w				varchar(255);
vl_pagto_w				double precision;
ds_mensagem_w			varchar(4000);

--Cursor que define os contratos que serão atualizados. (não poderão conter data de fim do contrato maior  ou igual a data de hoje, deve conter data de revisão e quantidade de dias para a revisão e deve estar ativo).
c01 CURSOR FOR
SELECT	nr_sequencia,
		qt_dias_revisao,
		dt_revisao,
		cd_setor,
		ds_objeto_contrato,
		substr(obter_razao_social(cd_cgc_contratado),1,80),
		substr(obter_descricao_padrao('TIPO_CONTRATO','DS_TIPO_CONTRATO',nr_seq_tipo_contrato),1,200),
		dt_inicio,
		dt_fim,
		trunc(dt_fim - clock_timestamp()),
		substr(obter_valor_dominio(1061, ie_renovacao),1,255),
		vl_total_contrato,
		substr(obter_desc_cond_pagto(cd_condicao_pagamento),1,80)
from	contrato
where	ie_situacao = 'A'
and		(qt_dias_revisao IS NOT NULL AND qt_dias_revisao::text <> '')
and		(dt_revisao IS NOT NULL AND dt_revisao::text <> '')
and		(cd_setor IS NOT NULL AND cd_setor::text <> '')
and		to_date(to_char(dt_revisao,'dd/mm/yyyy'),'dd/mm/yyyy') + qt_dias_revisao = to_date(to_char(clock_timestamp(),'dd/mm/yyyy'),'dd/mm/yyyy')
and		((to_date(to_char(dt_fim,'dd/mm/yyyy'),'dd/mm/yyyy') > to_date(to_char(clock_timestamp(),'dd/mm/yyyy'),'dd/mm/yyyy')) or (coalesce(dt_fim::text, '') = ''));

c02 CURSOR FOR
SELECT	nm_usuario_param,
		row_number() OVER () AS rownum
from	usuario_setor
where	cd_setor_atendimento = cd_setor_w;


BEGIN
--gerar C.I. e efetuar atualização da data de revisão
open C01;
loop
fetch C01 into
	nr_sequencia_w,
	qt_dias_revisao_w,
	dt_revisao_w,
	cd_setor_w,
	ds_objeto_contrato_w,
	nm_contratado_w,
	ds_tipo_contrato_w,
	dt_inicio_w,
	dt_fim_w,
	qt_dias_vencer_w,
	ds_forma_renovacao_w,
	vl_total_contrato_w,
	ds_condicao_pagamento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	--usuários a serem informados
	open C02;
	loop
	fetch C02 into
		nm_usuario_w,
		linha;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (linha <> 1) then
			nm_usuario_dest_w := nm_usuario_dest_w || ',' || nm_usuario_w;
		else
			nm_usuario_dest_w := nm_usuario_w;
		end if;
		end;
	end loop;
	close C02;
	ds_setor_w := to_char(cd_setor_w) || ',';
	--buscando campos para compor a menssagem
	select	max(substr(obter_valor_dominio(1062, ie_forma),1,255)),
			max(substr(obter_desc_moeda(cd_moeda),1,255)),
			max(vl_pagto)
	into STRICT	ds_forma_pagamento_w,
			ds_moeda_w,
			vl_pagto_w
	from	contrato_regra_pagto
	where	nr_seq_contrato = nr_sequencia_w;
	--montar menssagem
	ds_mensagem_w	:= 	substr(wheb_mensagem_pck.get_texto(312745,'NR_SEQUENCIA=' || nr_sequencia_w ||
						';DS_OBJETO_CONTRATO=' || ds_objeto_contrato_w ||
						';NM_CONTRATADO=' || nm_contratado_w ||
						';DS_TIPO_CONTRATO=' || ds_tipo_contrato_w ||
						';DS_OBJETO_CONTRATO=' || ds_objeto_contrato_w ||
						';DT_INICIO=' || dt_inicio_w ||
						';DT_FIM=' || dt_fim_w ||
						';QT_DIAS_VENCER=' || qt_dias_vencer_w ||
						';DS_FORMA_RENOVACAO=' || ds_forma_renovacao_w ||
						';VL_TOTAL_CONTRATO=' || vl_total_contrato_w ||
						';DS_CONDICAO_PAGAMENTO=' || ds_condicao_pagamento_w ||
						';DS_FORMA_PAGAMENTO=' || ds_forma_pagamento_w ||
						';DS_MOEDA=' || ds_moeda_w ||
						';DT_REVISAO=' || dt_revisao_w ||
						';VL_PAGTO=' || vl_pagto_w),1,4000);
	--enviar C.I.
	insert into comunic_interna(
				dt_comunicado,
				ds_titulo,
				ds_comunicado,
				nm_usuario,
				dt_atualizacao,
				ie_geral,
				nm_usuario_destino,
				nr_sequencia,
				ie_gerencial,
				nr_seq_classif,
				dt_liberacao,
				ds_setor_adicional,
				ds_perfil_adicional)
			values (	clock_timestamp() + interval '1 days'/86400,
				substr(wheb_mensagem_pck.get_texto(312736),1,255),
				ds_mensagem_w,
				'Tasy',
				clock_timestamp(),
				'N',
				nm_usuario_dest_w,
				nextval('comunic_interna_seq'),
				'N',
				null,
				clock_timestamp(),
				ds_setor_w,
				null);
	--Alterar data de revisão para a próxima data
	update	contrato
	set		dt_revisao = clock_timestamp() + qt_dias_revisao_w
	where	nr_sequencia = nr_sequencia_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hbh_atualiza_dt_revis_contrato ( cd_estabelecimento_p bigint) FROM PUBLIC;

