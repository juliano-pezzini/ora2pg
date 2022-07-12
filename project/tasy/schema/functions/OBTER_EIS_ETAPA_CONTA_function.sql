-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_eis_etapa_conta (nr_interno_conta_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_etapa_w		varchar(80)	:= null;
nr_seq_etapa_w		bigint	:= null;
ds_retorno_w		varchar(255)	:= null;
ds_observacao_w		varchar(255);
ie_muda_status_conta_w	varchar(01);
cd_setor_atendimento_w	integer;
cd_pessoa_fisica_w	varchar(10);
nr_seq_motivo_dev_w	varchar(80);

c01 CURSOR FOR
	SELECT	a.nr_seq_etapa,
		b.ds_etapa,
		substr(a.ds_observacao,1,255),
		coalesce(ie_muda_status_conta, 'S'),
		a.cd_setor_atendimento,
		a.cd_pessoa_fisica,
		a.nr_seq_motivo_dev
	from	fatur_etapa b,
		conta_paciente_etapa a
	where	a.nr_seq_etapa		= b.nr_sequencia
	and	a.nr_interno_conta	= nr_interno_conta_p
	and	coalesce(b.ie_situacao,'A')	= 'A'
	and	a.dt_etapa		=	(SELECT	/*+ index(a conpaet_conpaci_fk_i) */							max(x.dt_etapa)
   						 from	conta_paciente_etapa x
						 where   x.nr_interno_conta = nr_interno_conta_p)
	order by a.dt_etapa;



BEGIN

open	c01;
loop
fetch	c01 into
	nr_seq_etapa_w,
	ds_etapa_w,
	ds_observacao_w,
	ie_muda_status_conta_w,
	cd_setor_atendimento_w,
	cd_pessoa_fisica_w,
	nr_seq_motivo_dev_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (ie_opcao_p = 'C') then
		ds_retorno_w	:= nr_seq_etapa_w;
	elsif (ie_opcao_p = 'O') then
		ds_retorno_w	:= ds_observacao_w;
	elsif (ie_opcao_p = 'S') then
		ds_retorno_w	:= ie_muda_status_conta_w;
	elsif (ie_opcao_p = 'SE') then
		ds_retorno_w	:= cd_setor_atendimento_w;
	elsif (ie_opcao_p = 'P') then
		ds_retorno_w	:= cd_pessoa_fisica_w;
	elsif (ie_opcao_p = 'M') then
		ds_retorno_w	:= nr_seq_motivo_dev_w;
	else
		ds_retorno_w	:= ds_etapa_w;
	end if;

	end;
end loop;
close c01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_eis_etapa_conta (nr_interno_conta_p bigint, ie_opcao_p text) FROM PUBLIC;

