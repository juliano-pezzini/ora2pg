-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_suep_padrao ( nr_atendimento_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE

				 
nr_seq_suep_w			bigint;				
qt_regra_w				integer;
cd_pessoa_usuario_w		varchar(10);

C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	suep a 
	
	where	obter_se_suep_liberado_usuario(nr_sequencia, cd_pessoa_usuario_w,nr_atendimento_p) = 'S';

	 

BEGIN 
 
select	count(*) 
into STRICT	qt_regra_w	 
from	regra_liberacao_suep 
where	(nr_seq_suep IS NOT NULL AND nr_seq_suep::text <> '');
 
if (qt_regra_w > 0) then 
 
		cd_pessoa_usuario_w	:= obter_pf_usuario(nm_usuario_p,'C');
 
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_suep_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			nr_seq_suep_w	:= 	nr_seq_suep_w;
			end;
		end loop;
		close C01;
 
	 
else 
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_suep_w 
	from	suep;
--	where	ie_suep_padrao = 'S'; 
 
 
end if;
 
return	nr_seq_suep_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_suep_padrao ( nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
