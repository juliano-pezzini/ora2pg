-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE add_paciente_dest_carta ( nr_seq_carta_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text) AS $body$
DECLARE


nm_usuario_w			destinatario_carta_medica.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
nr_seq_modelo_w			carta_medica.nr_seq_modelo%type;
ie_incluso_w			participante_carta_medica.ie_incluso%type := 'N';

C01 CURSOR FOR
	SELECT	nm_usuario_resp,
			ie_incluso
	from	participante_carta_medica
	where	nr_seq_modelo = nr_seq_modelo_w
	order by nr_seq_apresent;

C02 CURSOR FOR
	SELECT 	obter_nome_pf(cd_medico) nm_destinatario_w,
			cd_medico cd_pessoa_fisica_w
	from 	pf_medico_externo
	where 	cd_pessoa_fisica = cd_pessoa_fisica_p
	
union all

	SELECT	obter_nome_pf(cd_pessoa_fisica_p) nm_destinatario_w,
			cd_pessoa_fisica_p cd_pessoa_fisica_w
	;

C03 CURSOR FOR
	SELECT	obter_nome_pf(cd_pessoa_fisica_p) nm_destinatario_w,
			cd_pessoa_fisica_p cd_pessoa_fisica_w
	
    
union all

    SELECT  obter_nome_pf(cd_medico) nm_destinatario_w,
            cd_medico cd_pessoa_fisica_w
    from    atend_consent_carta_med
    where   nr_atendimento = nr_atendimento_p
    and     ie_consentiu = 'S';

BEGIN

if (pkg_i18n.get_user_locale <> 'de_AT') then
begin
    for r_C02 in C02 loop
        begin
        insert into destinatario_carta_medica(nr_sequencia,
                                              dt_atualizacao,
                                              nm_usuario,
                                              nm_destinatario,
                                              dt_atualizacao_nrec,
                                              nm_usuario_nrec,
                                              nr_seq_carta_mae,
                                              cd_pessoa_fisica)
                                    values (nextval('destinatario_carta_medica_seq'),
                                              clock_timestamp(),
                                              nm_usuario_w,
                                              r_C02.nm_destinatario_w,
                                              clock_timestamp(),
                                              nm_usuario_w,
                                              nr_seq_carta_p,
                                              r_C02.cd_pessoa_fisica_w);
        end;
    end loop;
end;
else
begin
    for r_C03 in C03 loop
        begin
        insert into destinatario_carta_medica(nr_sequencia,
                                              dt_atualizacao,
                                              nm_usuario,
                                              nm_destinatario,
                                              dt_atualizacao_nrec,
                                              nm_usuario_nrec,
                                              nr_seq_carta_mae,
                                              cd_pessoa_fisica)
                                    values (nextval('destinatario_carta_medica_seq'),
                                              clock_timestamp(),
                                              nm_usuario_w,
                                              r_C03.nm_destinatario_w,
                                              clock_timestamp(),
                                              nm_usuario_w,
                                              nr_seq_carta_p,
                                              r_C03.cd_pessoa_fisica_w);
        end;
    end loop;
end;
end if;

select	max(nr_seq_modelo)
into STRICT	nr_seq_modelo_w
from	carta_medica
where	nr_seq_carta_mae = nr_seq_carta_p;

for r_C01 in C01 loop
	begin
	if (coalesce(r_C01.ie_incluso, 'N') = 'S') then
		ie_incluso_w := 'G';
	end if;
	CALL add_part_carta_medica(nr_seq_carta_p,nr_seq_carta_p,r_C01.nm_usuario_resp,'DA', ie_incluso_w);
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE add_paciente_dest_carta ( nr_seq_carta_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

