-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lib_repasse_fechamento_prot (nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_pagto_w			varchar(1);
ie_status_w			varchar(1);
cd_regra_w			bigint;

c_procedimentos CURSOR(	nr_seq_protocolo_pc	protocolo_convenio.nr_seq_protocolo%type) FOR
	SELECT	a.nr_sequencia
	from	procedimento_paciente a,
	conta_paciente b
	where	a.nr_interno_conta = b.nr_interno_conta
	and		b.nr_seq_protocolo = nr_seq_protocolo_pc;

c_materiais CURSOR(	nr_seq_protocolo_pc	protocolo_convenio.nr_seq_protocolo%type) FOR
	SELECT	a.nr_sequencia
	from	material_atend_paciente a,
	conta_paciente b
	where	a.nr_interno_conta = b.nr_interno_conta
	and		b.nr_seq_protocolo = nr_seq_protocolo_pc;
BEGIN

  for	r_c_procedimentos in c_procedimentos(nr_seq_protocolo_p) loop
		begin
			select max(a.cd_regra),
			max(ie_status)
			into STRICT	cd_regra_w,
			ie_status_w
			from	procedimento_repasse a
			where	a.nr_seq_procedimento = r_c_procedimentos.nr_sequencia;

			begin
				select	a.ie_pagto
				into STRICT	ie_pagto_w
				from	regra_repasse_terceiro a
				where	a.cd_regra	= cd_regra_w  LIMIT 1;
				exception
				when others then
					ie_pagto_w	:= null;
			end;

			if (ie_pagto_w	= 'F' and ie_status_w = 'A') then
				update procedimento_repasse
				set	vl_liberado	= vl_repasse,
					dt_liberacao	= clock_timestamp(),
					nm_usuario_lib	= nm_usuario_p,
					ie_status	= 'S'
				where	nr_seq_procedimento	= r_c_procedimentos.nr_sequencia;
			end if;
		end;
	end loop;

  for	r_c_materiais in c_materiais(nr_seq_protocolo_p) loop
		begin
			select	max(a.cd_regra),
			max(ie_status)
			into STRICT	cd_regra_w,
			ie_status_w
			from	material_repasse a
			where	a.nr_seq_material = r_c_materiais.nr_sequencia;

			begin
				select	a.ie_pagto
				into STRICT	ie_pagto_w
				from	regra_repasse_terceiro a
				where	a.cd_regra	= cd_regra_w  LIMIT 1;
				exception
				when others then
				  ie_pagto_w	:= null;
			end;

			if (ie_pagto_w	= 'F' and ie_status_w = 'A') then
				update	material_repasse
				set	vl_liberado	= vl_repasse,
					dt_liberacao	= clock_timestamp(),
					nm_usuario_lib	= nm_usuario_p,
					ie_status	= 'S'
				where	nr_seq_material	= r_c_materiais.nr_sequencia;
			end if;
		end;
  end loop;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lib_repasse_fechamento_prot (nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
