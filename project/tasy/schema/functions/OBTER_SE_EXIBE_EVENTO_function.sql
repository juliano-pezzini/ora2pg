-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_evento ( nr_sequencia_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

 
cd_pessoa_fisica_w	varchar(10);
ie_exibe_alerta_w	varchar(1);
					

BEGIN 
 
cd_pessoa_fisica_w := obter_dados_usuario_opcao(nm_usuario_p,'C');
 
select	coalesce(max('S'),'N') 
into STRICT	ie_exibe_alerta_w 
from	ev_evento_pac_destino a, 
	ev_evento_paciente b 
where	a.nr_seq_ev_pac		=	b.nr_sequencia 
and	b.nr_sequencia		=	nr_sequencia_p 
and	a.cd_pessoa_fisica	=	cd_pessoa_fisica_w;
 
 
return	ie_exibe_alerta_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_evento ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
