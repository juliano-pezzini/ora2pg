-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_indicador_contabil ( dt_parametro_p timestamp, nm_usuario_p text) AS $body$
DECLARE


cd_empresa_w		integer;
cd_estabelecimento_w	smallint;
dt_referencia_w		timestamp;
nr_seq_indicador_w		bigint;
cd_conta_w		varchar(20);
ds_conta_base_w		varchar(2000);
ds_conta_divisor_w		varchar(2000);
vl_base_w		double precision;
vl_base_ww		double precision;
vl_divisor_w		double precision;
vl_indicador_w		double precision;
nr_sequencia_w		bigint;
ds_comando_w		varchar(256);
ds_comando_ww		varchar(4000);
ie_anualizar_w		varchar(01);
ie_percentual_w		varchar(01);
qt_mes_w		smallint;
Guampa			varchar(1)		:= chr(39);
nr_seq_mes_ref_w		bigint;
ie_consol_empresa_w	varchar(1);
vl_base_consol_w		double precision;
vl_base_consol_ww	double precision;
vl_divisor_consol_w		double precision;

c01 CURSOR FOR
SELECT	cd_empresa,
	nr_sequencia,
	ds_conta_base,
	ds_conta_divisor,
	ie_anualizar,
	ie_percentual,
	coalesce(ie_consol_empresa,'N')
from	eis_indicador_contabil
where	ie_situacao = 'A';

c02 CURSOR FOR
SELECT	cd_estabelecimento
from	estabelecimento
where	cd_empresa = cd_empresa_w;


BEGIN


commit;
dt_referencia_w	:= trunc(dt_parametro_p, 'month');
select campo_numerico(to_char(dt_referencia_w,'mm'))
into STRICT	qt_mes_w
;

delete from eis_valor_indic_contab
where 	dt_referencia	= dt_referencia_w and coalesce(nr_seq_ind_base::text, '') = '';


open	c01;
loop
fetch	c01 into
	cd_empresa_w,
	nr_seq_indicador_w,
	ds_conta_base_w,
	ds_conta_divisor_w,
	ie_anualizar_w,
	ie_percentual_w,
	ie_consol_empresa_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	vl_base_consol_w	:= 0;
	vl_divisor_consol_w	:= 0;
	
	open c02;
	loop
	fetch c02 into
		cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		select	max(nr_sequencia)
		into STRICT	nr_seq_mes_ref_w
		from	ctb_mes_ref
		where	cd_empresa	= cd_empresa_w
		and	dt_referencia	= dt_referencia_w;

		select	ctb_Obter_Valor_Conta(nr_seq_mes_ref_w, ds_conta_base_w, cd_estabelecimento_w, null, 'S', null)
		into STRICT	vl_base_w
		;

		select	ctb_Obter_Valor_Conta(nr_seq_mes_ref_w, ds_conta_divisor_w, cd_estabelecimento_w, null,'S', null)
		into STRICT	vl_divisor_w
		;

		vl_base_ww		:= vl_base_w;
		if (ie_anualizar_w = 'S') then
			vl_base_w	:= dividir((vl_base_w * 12), qt_mes_w);
		end if;

		vl_indicador_w	:= dividir(vl_base_w, vl_divisor_w);
		if (ie_percentual_w = 'S') then
			vl_indicador_w	:= dividir(vl_base_w  * 100, vl_divisor_w);
		end if;

		if (ie_consol_empresa_w = 'S') then
			vl_base_consol_w	:= vl_base_consol_w + vl_base_ww;
			vl_divisor_consol_w	:= vl_divisor_consol_w + vl_divisor_w;
		end if;
		
		select nextval('eis_valor_indic_contab_seq')
		into STRICT	nr_sequencia_w
		;

		insert into eis_valor_indic_contab(
			nr_sequencia, cd_empresa, cd_estabelecimento, dt_referencia,
			nr_seq_indicador, dt_atualizacao,
			nm_usuario, vl_indicador,
			vl_base, vl_divisor)
		values (
			nr_sequencia_w, cd_empresa_w, cd_estabelecimento_w, dt_referencia_w,
			nr_seq_indicador_w, clock_timestamp(),
			nm_usuario_p, vl_indicador_w,
			vl_base_ww, vl_divisor_w);
		end;
	end loop;
	close c02;

	if (ie_consol_empresa_w = 'S') then
		vl_base_consol_ww	:= vl_base_consol_w;
		vl_divisor_consol_w		:= vl_divisor_consol_w;
			
		if (ie_anualizar_w = 'S') then
			vl_base_consol_w	:= dividir((vl_base_consol_w * 12), qt_mes_w);
		end if;

		vl_indicador_w			:= dividir(vl_base_consol_w, vl_divisor_consol_w);
		if (ie_percentual_w = 'S') then
			vl_indicador_w	:= dividir(vl_base_consol_w  * 100, vl_divisor_consol_w);
		end if;
			
		insert into eis_valor_indic_contab(
			nr_sequencia,
			cd_empresa,
			cd_estabelecimento,
			dt_referencia,
			nr_seq_indicador,
			dt_atualizacao,
			nm_usuario,
			vl_indicador,
			vl_base,
			vl_divisor)
		values (	nextval('eis_valor_indic_contab_seq'),
			cd_empresa_w,
			null,
			dt_referencia_w,
			nr_seq_indicador_w,
			clock_timestamp(),
			nm_usuario_p,
			vl_indicador_w,
			vl_base_consol_ww,
			vl_divisor_consol_w);
	end if;
	
	end;
end loop;
close c01;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_indicador_contabil ( dt_parametro_p timestamp, nm_usuario_p text) FROM PUBLIC;

