-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_autor_matpaci (nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
IE_OPCAO_P
1 - Retorna mensagem de consistencia
2 - Retorna qual a regra
*/
nr_atendimento_w	bigint;
cd_convenio_w		bigint;
ie_tipo_atendimento_w	smallint;
cd_setor_atendimento_w	bigint;
cd_plano_w		varchar(10) := '';
ds_erro_w		varchar(255) := '';
ds_retorno_w		varchar(255) := '';
ie_regra_w		varchar(10) := null;
nr_seq_regra_retorno_w	bigint;
cd_material_w		bigint;
dt_atendimento_w	timestamp;
qt_material_w		double precision;
ie_aux_w		varchar(50);
cd_estabelecimento_w	smallint;
nr_seq_mat_simp_w	material_atend_paciente.nr_seq_mat_simp%type;


BEGIN

begin
select	a.nr_atendimento,
	a.cd_convenio,
	a.dt_atendimento,	
	a.cd_material,
	a.qt_material,
	b.ie_tipo_atendimento,
	obter_plano_convenio_atend(b.nr_atendimento,'C'),
	a.cd_setor_atendimento,
	b.cd_estabelecimento,
	a.nr_seq_mat_simp
into STRICT	nr_atendimento_w,
	cd_convenio_w,
	dt_atendimento_w,
	cd_material_w,
	qt_material_w,
	ie_tipo_atendimento_w,
	cd_plano_w,
	cd_setor_atendimento_w,
	cd_estabelecimento_w,
	nr_seq_mat_simp_w
from	atendimento_paciente b,
	material_atend_paciente a
where	a.nr_atendimento	= b.nr_atendimento
and	a.nr_sequencia		= nr_sequencia_p;


SELECT * FROM consiste_mat_plano_convenio(	cd_convenio_w, cd_plano_w, cd_material_w, nr_atendimento_w, cd_Setor_Atendimento_w, ds_erro_w, ie_aux_w, ie_regra_w, nr_seq_regra_retorno_w, 0, /*  OS 463094 , troquei a qtde do material por zero para consistir corretamente */
				dt_atendimento_w, null, cd_estabelecimento_w, null, null, null, null, null, null, nr_seq_mat_simp_w) INTO STRICT ds_erro_w, ie_aux_w, ie_regra_w, nr_seq_regra_retorno_w;
exception
	when others then
		ds_erro_w		:= null;
		ie_regra_w		:= null;
end;

if (ie_opcao_p = '1') then
	if (ie_regra_w = 3) then	-- se consiste na conta
		ds_retorno_w		:= ds_erro_w;
	end if;
elsif (ie_opcao_p = '2') then
	ds_retorno_w	:= ie_regra_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_autor_matpaci (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
