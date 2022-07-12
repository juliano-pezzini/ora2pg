-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_legenda_leito (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


/*
PR - Previsto
PA - Previsto em atraso
EE - Em execucao
EX - Executado
CA - Cancelado
AC - Aguardando check-list
AP - Aprovado
CC - Com check-list
IT - Interditado
PS - Pausado
*/
ie_status_serv_p varchar(2);
ie_check_list_p varchar(2);
ie_cl_lib_p varchar(2);
dt_prevista_p timestamp;
dt_inicio_p timestamp;
param36_p varchar(2);--36 - Utilizar legenda de aguardando check-list, caso tenha servico gerado e nao tenha check-list
param49_p varchar(2);--49 - Na legenda somente considera a legenda com check-list caso o mesmo esteja liberado
BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then

param36_p := Obter_Valor_Param_Usuario(75 ,36, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
param49_p := Obter_Valor_Param_Usuario(75 ,49, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
	
		select
			b.ie_status_serv,			
			obter_se_servico_check_list(b.nr_sequencia) ie_check_list,
			obter_se_check_list_liberado(b.nr_sequencia) ie_cl_lib,
			b.dt_prevista,
			b.dt_inicio
		into STRICT
			ie_status_serv_p,
			ie_check_list_p,
			ie_cl_lib_p,
			dt_prevista_p,
			dt_inicio_p
		from sl_unid_atend b
		where nr_sequencia = nr_sequencia_p;
	
		if (coalesce(dt_inicio_p::text, '') = '' and clock_timestamp() > dt_prevista_p and ie_status_serv_p <> 'A' and
			ie_status_serv_p <> 'C' and ie_status_serv_p <> 'IT') then
			return 'PA';	
		elsif (ie_status_serv_p = 'C')  then
			return 'CA';		
		elsif (ie_status_serv_p = 'IT')  then
			return 'IT';
		elsif (ie_status_serv_p = 'E' and ie_check_list_p = 'N' and param36_p <> 'S')  then
			return 'EX';				
		elsif (ie_status_serv_p <> 'C') and ((ie_status_serv_p = 'E' and ie_check_list_p = 'N'  and param36_p = 'S' )	or (param49_p = 'S' and ie_cl_lib_p = 'N' and ie_check_list_p = 'S')) then
			return 'AC';
		elsif (ie_status_serv_p = 'P')  then
			return 'PR';
		elsif (ie_status_serv_p = 'IP')  then
			return 'PS';
		elsif (ie_status_serv_p = 'EE' or ie_status_serv_p = 'FP')  then
			return 'EE';
		elsif (ie_status_serv_p = 'A')  then
			return 'AP';
		elsif (ie_status_serv_p = 'E' and ie_check_list_p = 'S')  then
			return 'CC';		
		elsif (ie_status_serv_p = 'IT')  then
			return 'IT';				
		end if;	
	
end if;	

return '';		

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_legenda_leito (nr_sequencia_p bigint) FROM PUBLIC;

