-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_cheque_cr (nr_seq_cheque_p bigint, dt_referencia_p timestamp, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE


/*

Edgar 09/01/2009 OS 123111

Function para retornar:
	* Caso o cheque esteja em depósito: 		retornar a última data que o cheque foi depositado
	* Caso o cheque esteja devolvido: 		retornar a última data que o cheque foi devolvido
	* Caso o cheque esteja devolvido ao paciente: 	retornar a data que o cheque foi devolvido ao paciente


ie_opcao_p
	1 - Data de depósito na data de referência
	2 - Data de devolução na data de referência
	3 - Data de devolução ao paciente na data de referência

	10 - Data de Depósito
	20 - Data de Devolução
	30 - Data de Reapresenrtação
	40 - Data de Segunda Devolução
	50 - Data de Segunda Reapresentação
	60 - Data de Terceira Devolução
	70 - Data de Devolução ao Paciente

*/
nr_seq_cheque_w		bigint;
dt_evento_w		timestamp;
ie_tipo_data_w		bigint;
dt_deposito_w		timestamp;
dt_devolucao_w		timestamp;
dt_devolucao_pac_w	timestamp;
dt_retorno_w		timestamp;
dt_reapresentacao_w	timestamp;
dt_seg_devolucao_w	timestamp;
dt_seg_reapresentacao_w	timestamp;
dt_terc_devolucao_w	timestamp;


c01 CURSOR FOR
SELECT	a.nr_seq_cheque,
	trunc(a.dt_evento, 'dd'),
	a.ie_tipo_data
from (
	SELECT	trunc(coalesce(dt_deposito, dt_referencia_p + 1), 'dd') dt_evento,
		nr_seq_cheque,
		1 ie_tipo_data
	from	cheque_cr
	
union all

	select	trunc(coalesce(dt_devolucao_banco, dt_referencia_p + 1), 'dd') dt_evento,
		nr_seq_cheque,
		2 ie_tipo_data
	from	cheque_cr
	
union all

	select	trunc(coalesce(dt_reapresentacao, dt_referencia_p + 1), 'dd') dt_evento,
		nr_seq_cheque,
		3 ie_tipo_data
	from	cheque_cr
	
union all

	select	trunc(coalesce(dt_seg_devolucao, dt_referencia_p + 1), 'dd') dt_evento,
		nr_seq_cheque,
		4 ie_tipo_data
	from	cheque_cr
	
union all

	select	trunc(coalesce(dt_seg_reapresentacao, dt_referencia_p + 1), 'dd') dt_evento,
		nr_seq_cheque,
		5 ie_tipo_data
	from	cheque_cr
	
union all

	select	trunc(coalesce(dt_terc_devolucao, dt_referencia_p + 1), 'dd') dt_evento,
		nr_seq_cheque,
		6 ie_tipo_data
	from	cheque_cr
	
union all

	select	trunc(coalesce(dt_devolucao, dt_referencia_p + 1), 'dd') dt_evento,
		nr_seq_cheque,
		7 ie_tipo_data
	from	cheque_cr
	) a
where	a.nr_seq_cheque			= nr_seq_cheque_p
and	trunc(a.dt_evento, 'dd')	<= trunc(dt_referencia_p, 'dd')
order 	by a.dt_evento;




BEGIN

dt_deposito_w			:= null;
dt_devolucao_w			:= null;
dt_devolucao_pac_w		:= null;

dt_reapresentacao_w		:= null;
dt_seg_devolucao_w		:= null;
dt_seg_reapresentacao_w		:= null;
dt_terc_devolucao_w		:= null;

open c01;
loop
fetch c01 into
	nr_seq_cheque_w,
	dt_evento_w,
	ie_tipo_data_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (ie_opcao_p in (1,2,3)) then
		if (ie_tipo_data_w	in (1,3,5)) then	/* Depositado, Reapresentado, Segunda Reapresentação */
			dt_deposito_w		:= dt_evento_w;
			dt_devolucao_w		:= null;	-- Não está devolvido pelo banco
		elsif (ie_tipo_data_w	in (2,4,6)) then	/* Devolvido, Segunda Devolução, Terceira Devolução */
			dt_devolucao_w		:= dt_evento_w;
			dt_deposito_w		:= null;	-- Não está depositado
		elsif (ie_tipo_data_w	= 7) then		/* Devolução ao paciente */
			dt_devolucao_pac_w	:= dt_evento_w;
			dt_deposito_w		:= null;	-- Não está depositado
			dt_devolucao_w		:= null;	-- Não está devolvido pelo banco
		end if;
	else
		if (ie_tipo_data_w	= 1) then
			dt_deposito_w			:= dt_evento_w;
		elsif (ie_tipo_data_w	= 2) then
			dt_devolucao_w			:= dt_evento_w;
		elsif (ie_tipo_data_w	= 3) then
			dt_reapresentacao_w		:= dt_evento_w;
		elsif (ie_tipo_data_w	= 4) then
			dt_seg_devolucao_w		:= dt_evento_w;
		elsif (ie_tipo_data_w	= 5) then
			dt_seg_reapresentacao_w		:= dt_evento_w;
		elsif (ie_tipo_data_w	= 6) then
			dt_terc_devolucao_w		:= dt_evento_w;
		elsif (ie_tipo_data_w	= 7) then
			dt_devolucao_pac_w		:= dt_evento_w;
		end if;
	end if;

end loop;
close c01;

if (ie_opcao_p = 1) then
	dt_retorno_w	:= dt_deposito_w;
elsif (ie_opcao_p = 2) then
	dt_retorno_w	:= dt_devolucao_w;
elsif (ie_opcao_p = 3) then
	dt_retorno_w	:= dt_devolucao_pac_w;
elsif (ie_opcao_p = 10) then
	dt_retorno_w	:= dt_deposito_w;
elsif (ie_opcao_p = 20) then
	dt_retorno_w	:= dt_devolucao_w;
elsif (ie_opcao_p = 30) then
	dt_retorno_w	:= dt_reapresentacao_w;
elsif (ie_opcao_p = 40) then
	dt_retorno_w	:= dt_seg_devolucao_w;
elsif (ie_opcao_p = 50) then
	dt_retorno_w	:= dt_seg_reapresentacao_w;
elsif (ie_opcao_p = 60) then
	dt_retorno_w	:= dt_terc_devolucao_w;
elsif (ie_opcao_p = 70) then
	dt_retorno_w	:= dt_devolucao_pac_w;
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_cheque_cr (nr_seq_cheque_p bigint, dt_referencia_p timestamp, ie_opcao_p text) FROM PUBLIC;
