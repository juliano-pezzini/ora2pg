-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_conversao_hbo (cd_convenio_p bigint) AS $body$
DECLARE



cd_procedimento_w			bigint;
cd_procedimento_convenio_w		varchar(15);
ds_proc_convenio_w			varchar(255);

c01 CURSOR FOR
SELECT	TSU_COD,
	tsu_codins,
	tsu_des
from (select 00000301 tsu_cod, 2010006 tsu_codins, 'SALA DE CIRURGIA PRIM/HORA INDIVIS'  tsu_des
union all

select 00000302 tsu_cod, 2010001 tsu_codins, 'SALA CIRURGIA SUBSQUENTE 1/2 HORA'  tsu_des  
union all

select 00000304 tsu_cod, 2010033 tsu_codins, 'SALA RECUPERACAO ATE 4 HORAS'  tsu_des  
union all

select 00000306 tsu_cod, 2010075 tsu_codins, 'SALA CIRURGIA PEQUENO PORTE'  tsu_des  
union all

select 00000307 tsu_cod, 2010032 tsu_codins, 'SALA RECUP CIRURG AMBL C/ANES GERAL'  tsu_des  
union all

select 00000601 tsu_cod, 2050012 tsu_codins, 'OXIGENIO NA SALA DE CIRURGIA'  tsu_des  
union all

select 00000603 tsu_cod, 2050015 tsu_codins, 'OXIGENIO NA SALA RECUPERACAO'  tsu_des  
union all

select 00000604 tsu_cod, 2050018 tsu_codins, 'PROTOXIDO DE AZOTO P/MINUTO'  tsu_des  
union all

select 00000605 tsu_cod, 0 tsu_codins, 'GAS SF-6'  tsu_des  
union all

select 00000606 tsu_cod, 2050003 tsu_codins, 'GAS CARBONICO P/CONGELAMENTO'  tsu_des  
union all

select 00000804 tsu_cod, 2070024 tsu_codins, 'CURATIVOS OFTALMOLOGICOS'  tsu_des  
union all

select 00000901 tsu_cod, 2080015 tsu_codins, 'BISTURI BIPOLAR/DIATERMIA'  tsu_des  
union all

select 00000902 tsu_cod, 2080110 tsu_codins, 'AMOIS OU CRYO'  tsu_des  
union all

select 00000903 tsu_cod, 2080017 tsu_codins, 'CAUTERIO/BISTURI ELETRICO'  tsu_des  
union all

select 00000907 tsu_cod, 2080041 tsu_codins, 'DESFIBRILADOR'  tsu_des  
union all

select 00000908 tsu_cod, 2080045 tsu_codins, 'ELETRO IMA'  tsu_des  
union all

select 00000001 tsu_cod, 0 tsu_codins, 'SEMI-PRIVATIVO'  tsu_des  
union all

select 00000915 tsu_cod, 2080086 tsu_codins, 'TONOMETRO'  tsu_des  
union all

select 00000916 tsu_cod, 2080088 tsu_codins, 'TRANSILUMINADOR'  tsu_des  
union all

select 00000917 tsu_cod, 2080092 tsu_codins, 'VITREOGRAFO (SITE)'  tsu_des  
union all

select 00000919 tsu_cod, 2080028 tsu_codins, 'CARRO DE ANESTESIA'  tsu_des  
union all

select 00000002 tsu_cod, 0 tsu_codins, 'PRIVATIVO'  tsu_des  
union all

select 00000801 tsu_cod, 2070063 tsu_codins, 'ORIENTACAO NUTRICIONAL'  tsu_des  
union all

select 00000923 tsu_cod, 2080046 tsu_codins, 'ENDOLASER'  tsu_des  
union all

select 00000925 tsu_cod, 2080106 tsu_codins, 'FACOEMULSIFICADOR'  tsu_des  
union all

select 00008184 tsu_cod, 2080105 tsu_codins, 'USO DO APARELHO YAG LASER'  tsu_des  
union all

select 00000928 tsu_cod, 2080070 tsu_codins, 'MICROSCOPIO CIRURG(FIBRA OTICA)/MIN'  tsu_des  
union all

select 00000929 tsu_cod, 2020003 tsu_codins, 'MONOTORIZACAO COM CAPINOGRAFO'  tsu_des  
union all

select 00001001 tsu_cod, 2040001 tsu_codins, 'TX EXPEDIENTE P/PACIENTE INTERNADO'  tsu_des  
union all

select 00001002 tsu_cod, 2040002 tsu_codins, 'TX EXPEDIENTE PACIENTE AMBULATORIO'  tsu_des  
union all

select 00009102 tsu_cod, 2020026 tsu_codins, 'MONITOR CARDIACO P/HORA'  tsu_des  
union all

select 00009182 tsu_cod, 2020028 tsu_codins, 'OXIMETRO P/HORA'  tsu_des  
union all

select 00009211 tsu_cod, 2060001 tsu_codins, 'ASPIRACAO A VACUO P/HORA'  tsu_des  
union all

select 00000807 tsu_cod, 2050007 tsu_codins, 'NEBULIZACAO P/APLICACAO'  tsu_des  
union all

select 00000007 tsu_cod, 0 tsu_codins, 'ACOMPANHANTE'  tsu_des  
union all

select 00000040 tsu_cod, 0 tsu_codins, 'CONSULTA AMBULATORIAL DIURNA HBO'  tsu_des  
union all

select 00000060 tsu_cod, 0 tsu_codins, 'CONSULTA AMBULATORIAL NOTURNA HBO'  tsu_des  
union all

select 00000050 tsu_cod, 0 tsu_codins, 'CONSULTA AMBULATORIAL NOTURNA'  tsu_des  
union all

select 00000042 tsu_cod, 0 tsu_codins, 'CONSULTA AMBULATORIAL DIURNA'  tsu_des  
union all

select 00000602 tsu_cod, 2050014 tsu_codins, 'OXIGENIO SUBSEQUENTE POR MINUTO'  tsu_des  
union all

select 00010014 tsu_cod, 0 tsu_codins, 'CONSULTA DIURNA'  tsu_des  
union all

select 00000041 tsu_cod, 1 tsu_codins, 'TAXAS DE INSUMO UNIMED P.ATENDIMENT'  tsu_des  
union all

select 00000040 tsu_cod, 40 tsu_codins, 'MAT/MED PRONTO ATENDIMENTO'  tsu_des  
union all

select 02080104 tsu_cod, 2080104 tsu_codins, 'FOTOCOAGULACAO A LASER'  tsu_des  
union all

select 50060015 tsu_cod, 2080104 tsu_codins, 'FOTOCOAGULACAO A LASER'  tsu_des  
union all

select 50140019 tsu_cod, 2080104 tsu_codins, 'FOTOCOAGULACAO A LASER'  tsu_des ) alias0;



BEGIN

open c01;
loop
fetch c01 into
	cd_procedimento_w,
	cd_procedimento_convenio_w,
	ds_proc_convenio_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	begin
	insert into conversao_proc_convenio(NR_SEQUENCIA          ,
		CD_CONVENIO            ,
		CD_PROC_CONVENIO       ,
		DT_ATUALIZACAO         ,
		NM_USUARIO             ,
		CD_AREA_PROCED         ,
		CD_ESPECIAL_PROCED     ,
		CD_GRUPO_PROCED        ,
		CD_PROCEDIMENTO        ,
		IE_ORIGEM_PROCED       ,
		DS_PROC_CONVENIO       ,
		CD_GRUPO               ,
		TX_CONVERSAO_QTDE      ,
		CD_UNIDADE_CONVENIO    ,
		IE_SITUACAO            ,
		CD_ESPECIALIDADE_MEDICA,
		IE_TIPO_ATENDIMENTO    ,
		CD_SETOR_ATENDIMENTO)
	SELECT	nextval('conversao_proc_convenio_seq'),
		cd_convenio_p,
		cd_procedimento_convenio_w,
		clock_timestamp()         ,
		'TASY CONVERSAO'             ,
		null         ,
		null     ,
		null        ,
		cd_procedimento_w        ,
		4       ,
		ds_proc_convenio_w       ,
		null,
		null ,
		null ,
		'A',
		null,
		null,
		null
	;
	RAISE NOTICE 'Proc convertido: %', cd_procedimento_w;
	exception
		when others then
			RAISE NOTICE 'Proc ñ convertido: %', cd_procedimento_w;
	end;

end loop;
close c01;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_conversao_hbo (cd_convenio_p bigint) FROM PUBLIC;

