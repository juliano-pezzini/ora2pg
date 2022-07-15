-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aplicar_tx_comerc_aut_mat (nr_seq_autorizacao_p bigint, ie_reducao_acrescimo_p text, nm_usuario_p text) AS $body$
DECLARE

			

cd_estabelecimento_w	integer := Wheb_usuario_pck.Get_Cd_estabelecimento;	
cd_estab_autor_w	integer;		
cd_material_w		bigint;
pr_adicional_w		double precision;
ie_reducao_acrescimo_w	varchar(1);
cd_convenio_w		bigint;
nr_seq_agenda_w		autorizacao_cirurgia.nr_seq_agenda%type;
nr_atendimento_w	bigint;
nr_seq_autor_conv_w	bigint;

C01 CURSOR FOR
	SELECT	cd_material
	from	material_autor_cirurgia
	where	nr_seq_autorizacao = nr_seq_autorizacao_p;


BEGIN
if (nr_seq_autorizacao_p > 0) then
	
	select	cd_estabelecimento,
		nr_seq_agenda,
		nr_seq_autor_conv,
		nr_atendimento
	into STRICT	cd_estab_autor_w,
		nr_seq_agenda_w,
		nr_seq_autor_conv_w,
		nr_atendimento_w
	from	autorizacao_cirurgia
	where	nr_sequencia = nr_seq_autorizacao_p;
	
	if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
		
		select	max(cd_convenio)
		into STRICT	cd_convenio_w
		from	atend_categoria_convenio
		where	nr_seq_interno = obter_atecaco_atendimento(nr_atendimento_w);
		
	elsif (nr_seq_agenda_w IS NOT NULL AND nr_seq_agenda_w::text <> '') then
	
		select	max(cd_convenio)
		into STRICT	cd_convenio_w
		from	agenda_paciente
		where	nr_sequencia = nr_seq_agenda_w;
		
	elsif (nr_seq_autor_conv_w IS NOT NULL AND nr_seq_autor_conv_w::text <> '') then
	
		select	max(cd_convenio)
		into STRICT	cd_convenio_w
		from	autorizacao_Convenio
		where	nr_sequencia = nr_seq_autor_conv_w;
		
	end if;
	
	
	if (coalesce(ie_reducao_acrescimo_p,'X') = 'X') then
		
		open C01;
		loop
		fetch C01 into	
			cd_material_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			SELECT * FROM obter_tx_reducao_acresc_conv(cd_convenio_w, coalesce(cd_estab_autor_w,cd_estabelecimento_w), clock_timestamp(), cd_material_w, null, null, null, pr_adicional_w, ie_reducao_acrescimo_w) INTO STRICT pr_adicional_w, ie_reducao_acrescimo_w;
			
			update	material_autor_cirurgia
			set	ie_reducao_acrescimo = ie_reducao_acrescimo_w,
				pr_adicional	     = pr_adicional_w,
				dt_atualizacao	     = clock_timestamp(),
				nm_usuario 	     = nm_usuario_p
			where	nr_seq_autorizacao   = nr_seq_autorizacao_p
			and	cd_material	     = cd_material_w;
			
			end;
		end loop;
		close C01;
		
		
	elsif (coalesce(ie_reducao_acrescimo_p,'X') <> 'X') then
	
		update	material_autor_cirurgia
		set	ie_reducao_acrescimo 	= ie_reducao_acrescimo_p,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_seq_autorizacao	= nr_seq_autorizacao_p;
		
	end if;
end if;


commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aplicar_tx_comerc_aut_mat (nr_seq_autorizacao_p bigint, ie_reducao_acrescimo_p text, nm_usuario_p text) FROM PUBLIC;

