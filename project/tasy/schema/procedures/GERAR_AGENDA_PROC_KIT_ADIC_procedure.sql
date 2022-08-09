-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_agenda_proc_kit_adic ( nr_seq_agenda_p bigint, nr_seq_proc_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_ordem_w		   varchar(1);
cd_procedimento_w	  bigint;
ie_origem_proced_w	bigint;
cd_kit_material_w		integer;
nr_sequencia_w		  bigint;
nr_seq_kit_w		  bigint;	
ie_gerado_w		   varchar(1) := 'N';
ds_erro_w		   varchar(255);
ie_estab_agenda_w	  varchar(1);	
cd_estabelecimento_w	smallint;
qt_idade_w			  varchar(255);
				
C01 CURSOR FOR 
 
SELECT	c.cd_kit_material, 
     b.cd_procedimento, 
     b.ie_origem_proced 
from 	proc_interno b, 
     proc_interno_kit c, 
     kit_material d 
where	b.nr_sequencia 		  = nr_seq_proc_p 
and  c.nr_seq_proc_interno 	= b.nr_sequencia 
and	c.cd_kit_material 	  = d.cd_kit_material 
and	coalesce(d.ie_situacao,'A') = 'A' 
and	c.cd_estabelecimento 	= cd_estabelecimento_w 
and  qt_idade_w       between obter_idade_kit_proced(c.nr_sequencia,'MIN') 
                 and obter_idade_kit_proced(c.nr_sequencia,'MAX');


BEGIN 
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
 
ie_estab_agenda_w := Obter_Param_Usuario(871, 531, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_estab_agenda_w);
 
 
if (ie_estab_agenda_w = 'S') then 
	cd_estabelecimento_w := obter_estab_agenda_paciente(nr_seq_agenda_p);
end if;	
 
begin 
select 	max(coalesce(obter_idade_pf(a.cd_pessoa_fisica, clock_timestamp(), 'DIA'), 0)) 
into STRICT   qt_idade_w 
from   agenda_paciente a 
where  a.nr_sequencia = nr_seq_agenda_p;
exception 
  when others then 
  qt_idade_w := 0;
end;
 
 
open C01;
loop 
fetch C01 into	 
	cd_kit_material_w, 
	cd_procedimento_w, 
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	ds_erro_w := null;
	ds_erro_w := consistir_pedido_kit(cd_kit_material_w, nm_usuario_p, nr_seq_agenda_p, ds_erro_w);
		 
	select	min(a.nr_sequencia) 
	into STRICT	  nr_sequencia_w 
	from 	agenda_pac_pedido a, 
      agenda_pac_pedido_kit b 
	where 	a.nr_sequencia = b.nr_seq_pedido 
	and 	  a.nr_seq_agenda = nr_seq_agenda_p 
	and 	  coalesce(a.dt_liberacao::text, '') = '';
	 
	 
		 
	select	nextval('agenda_pac_pedido_kit_seq') 
	into STRICT	  nr_seq_kit_w 
	;
	 
	if (nr_sequencia_w > 0) and (coalesce(ds_erro_w::text, '') = '') then 
		begin 
		insert 	into agenda_pac_pedido_kit( 
         nr_sequencia, 
         dt_atualizacao, 
         nm_usuario, 
         dt_atualizacao_nrec, 
         nm_usuario_nrec, 
         nr_seq_pedido, 
         cd_kit_material, 
         cd_procedimento, 
         ie_origem_proced) 
		values (	nr_seq_kit_w, 
         clock_timestamp(), 
         nm_usuario_p, 
         clock_timestamp(), 
         nm_usuario_p, 
         nr_sequencia_w, 
         cd_kit_material_w, 
         cd_procedimento_w, 
         ie_origem_proced_w);
		end;		
	end if;			
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_agenda_proc_kit_adic ( nr_seq_agenda_p bigint, nr_seq_proc_p bigint, nm_usuario_p text) FROM PUBLIC;
