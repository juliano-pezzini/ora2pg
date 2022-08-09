-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rp_desfazer_liberacao_ausencia ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, cd_substituto_p text, dt_inicial_P timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_agenda_w			    agenda_consulta.nr_sequencia%type;
ie_status_agenda_prof_aus_w	varchar(3);

C01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	agenda a,
		agenda_consulta b
	where	a.cd_agenda = b.cd_agenda
	and	a.cd_tipo_agenda = 5
	and	b.cd_medico = coalesce(cd_substituto_p,cd_pessoa_fisica_p)
	and	b.dt_agenda between trunc(dt_inicial_p) and dt_final_p + 86399/86400
	and	(
		(exists (SELECT 1 from rp_pac_modelo_agend_item
			where	cd_medico_exec = cd_pessoa_fisica_p and nr_sequencia = b.nr_seq_rp_mod_item)) 
		or (exists (select 1 from rp_pac_agend_individual 
			where cd_medico_exec = cd_pessoa_fisica_p and nr_sequencia = b.nr_seq_rp_item_ind)))
	and	((b.ie_status_agenda = ie_status_agenda_prof_aus_w) or (cd_substituto_p IS NOT NULL AND cd_substituto_p::text <> ''));
	

BEGIN

select	max(ie_status_agenda_prof_aus)
into STRICT	ie_status_agenda_prof_aus_w
from	rp_parametros
where	cd_estabelecimento = cd_estabelecimento_p;

open C01;
loop
fetch C01 into	
	nr_seq_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (coalesce(cd_substituto_p::text, '') = '') then			
		update	agenda_consulta
		set	ie_status_agenda	= 'N',
			ds_motivo_status	 = NULL,
			cd_motivo_cancelamento	 = NULL
		where	nr_sequencia		= nr_seq_agenda_w;
	end if;
	if (cd_substituto_p IS NOT NULL AND cd_substituto_p::text <> '') then
		update	agenda_consulta
		set	cd_medico		= cd_pessoa_fisica_p
		where	nr_sequencia		= nr_seq_agenda_w;
	end if;
				
	end;
end loop;
close C01;

update	rp_licenca_profissional
set	dt_liberacao		 = NULL,
	nm_usuario_liberacao	 = NULL
where	nr_sequencia		= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rp_desfazer_liberacao_ausencia ( nr_sequencia_p bigint, cd_pessoa_fisica_p text, cd_substituto_p text, dt_inicial_P timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;
