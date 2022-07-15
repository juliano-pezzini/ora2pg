-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_pastas_agenda ( nr_seq_agenda_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

					 
ie_pasta_w		varchar(15);
cd_estab_agenda_w	smallint;
qt_registros_w		bigint;
					
c01 CURSOR FOR 
	SELECT	ie_pasta 
	from  	consistencia_pasta_agenda 
	where 	cd_estabelecimento = cd_estab_agenda_w;
					

BEGIN 
 
delete from agenda_consistencia_pasta where nr_seq_agenda = nr_seq_agenda_p;
 
select	max(a.cd_estabelecimento) 
into STRICT	cd_estab_agenda_w 
from	agenda a, 
	agenda_paciente b 
where	a.cd_agenda 	= b.cd_agenda 
and	b.nr_sequencia	= nr_seq_agenda_p;
 
open c01;
loop 
fetch c01 into 
	ie_pasta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	if (ie_pasta_w = 'E') then 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	agenda_pac_equip 
		where	nr_seq_agenda = nr_seq_agenda_p 
		and	coalesce(ie_origem_inf,'I') = 'I';
	elsif (ie_pasta_w = 'C') then 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	agenda_pac_cme 
		where	nr_seq_agenda = nr_seq_agenda_p 
		and	coalesce(ie_origem_inf,'I') = 'I';
	elsif (ie_pasta_w = 'I') then 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	agenda_pac_desc_material 
		where	nr_seq_agenda = nr_seq_agenda_p;
	elsif (ie_pasta_w = 'S') then 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	agenda_pac_servico 
		where	nr_seq_agenda = nr_seq_agenda_p 
		and	coalesce(ie_origem_inf,'I') = 'I';
	end if;
	CALL inserir_agenda_consiste_pasta(nr_seq_agenda_p,ie_pasta_w,qt_registros_w,nm_usuario_p,cd_estabelecimento_p);
	end;
end loop;
close c01;
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_pastas_agenda ( nr_seq_agenda_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

