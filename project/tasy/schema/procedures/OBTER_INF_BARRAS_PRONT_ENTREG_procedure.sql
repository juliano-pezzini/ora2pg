-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_inf_barras_pront_entreg ( dt_final_p timestamp, dt_inicial_p timestamp, ie_tipo_data_p bigint, nr_prontuario_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nm_pessoa_p INOUT text, nr_sequencia_p INOUT bigint) AS $body$
BEGIN
 
select OBTER_NOME_PF(CD_PESSOA_FISICA) 
into STRICT	nm_pessoa_p  
from  pessoa_fisica          
where  nr_prontuario = nr_prontuario_p;
 
select nr_sequencia 
into STRICT	nr_sequencia_p 
from  same_solic_pront 
where  coalesce(nr_seq_lote::text, '') = '' 
and   ie_status = 'P' 
and	obter_prontuario_pf(coalesce(cd_estabelecimento_solic, cd_estabelecimento), cd_pessoa_fisica) = nr_prontuario_p 
and	((obter_valor_param_usuario(941,103,obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p) = 'N') or (cd_estabelecimento = cd_estabelecimento_p)) 
and	((obter_valor_param_usuario(941,141,obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p) = 'N') 
or (ie_tipo_data_p = 0 and dt_solicitacao between dt_inicial_p and fim_dia(dt_final_p)) 
or (ie_tipo_data_p = 1 and dt_prevista between dt_inicial_p and fim_dia(dt_final_p)) 
or (ie_tipo_data_p = 2 and dt_entrega between dt_inicial_p and fim_dia(dt_final_p)) 
or (ie_tipo_data_p = 3));
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_inf_barras_pront_entreg ( dt_final_p timestamp, dt_inicial_p timestamp, ie_tipo_data_p bigint, nr_prontuario_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nm_pessoa_p INOUT text, nr_sequencia_p INOUT bigint) FROM PUBLIC;

