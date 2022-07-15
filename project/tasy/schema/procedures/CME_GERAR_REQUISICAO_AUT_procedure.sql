-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_gerar_requisicao_aut ( dt_agenda_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_agenda_w		            agenda_paciente.nr_sequencia%type;
nr_seq_requisicao_w	bigint;
cd_setor_atendimento_w	setor_atendimento.cd_setor_atendimento%type;
cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nm_usuario_orig_w	usuario.nm_usuario%type;
dt_agenda_w		agenda_paciente.dt_agenda%type;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		substr(obter_pf_usuario(nm_usuario_orig, 'C'),1,80),
		obter_estab_agenda_paciente(nr_sequencia),
		nm_usuario_orig,
		dt_agenda
	from	agenda_paciente
	where	trunc(dt_agenda) = trunc(dt_agenda_p - 1)
	and     ie_status_agenda not in ('L','I','C','B','F')
	and	(nm_usuario_orig IS NOT NULL AND nm_usuario_orig::text <> '');


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_agenda_w,
	cd_pessoa_fisica_w,
	cd_estabelecimento_w,
	nm_usuario_orig_w,
	dt_agenda_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	max(cd_setor_atendimento)
	into STRICT	cd_setor_atendimento_w
	from	usuario
	where	nm_usuario = nm_usuario_orig_w;
	
	if (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '') then
		nr_seq_requisicao_w := cme_gerar_requisicao(nr_seq_agenda_w, cd_pessoa_fisica_w, cd_setor_atendimento_w, cd_estabelecimento_w, nm_usuario_p, nr_seq_requisicao_w);
		
		update	cm_requisicao
		set	dt_liberacao = dt_agenda_w,
			dt_requisicao = dt_agenda_w
		where	nr_sequencia = nr_seq_requisicao_w;
		
	end if;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_gerar_requisicao_aut ( dt_agenda_p timestamp, nm_usuario_p text) FROM PUBLIC;

