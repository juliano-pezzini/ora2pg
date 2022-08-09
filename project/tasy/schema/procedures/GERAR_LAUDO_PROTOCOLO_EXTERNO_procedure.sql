-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_laudo_protocolo_externo ( nr_Seq_pac_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_procedimento_w		bigint;
ds_procedimento_w		varchar(255);
nr_atendimento_w		bigint;
dt_exame_w			timestamp;
nr_seq_imagem_prot_ext_w	bigint;
cd_medico_w			varchar(10);
nr_laudo_w			bigint;
cd_pessoa_fisica_w		varchar(10);
nr_seq_laudo_w			bigint;

c01 CURSOR FOR
	SELECT 	cd_procedimento,
		obter_descricao_procedimento(cd_procedimento,ie_origem_proced)
	from	imagem_protocolo_ext_item
	where	nr_seq_imagem_prot_ext = nr_seq_imagem_prot_ext_w;


BEGIN

select 	max(nr_atendimento),
	max(dt_exame),
	max(nr_seq_imagem_prot_ext),
	max(cd_medico),
	max(cd_pessoa_fisica)
into STRICT	nr_atendimento_w,
	dt_exame_w,
	nr_seq_imagem_prot_ext_w,
	cd_medico_w,
	cd_pessoa_fisica_w
from	imagem_pac_prot_externo
where 	nr_sequencia = nr_Seq_pac_protocolo_p;

open c01;
loop
fetch c01 into 	cd_procedimento_w,
		ds_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	

	if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
		select 	coalesce(max(nr_laudo),0)+1
		into STRICT	nr_laudo_w
		from 	laudo_paciente 
		where 	nr_atendimento = nr_atendimento_w;
	else
		select 	coalesce(max(nr_laudo),0)+1
		into STRICT	nr_laudo_w
		from 	laudo_paciente 
		where 	cd_pessoa_fisica = cd_pessoa_fisica_w;
	end if;
	
	select	nextval('laudo_paciente_seq')
	into STRICT	nr_seq_laudo_w
	;
	
	insert into laudo_paciente(	nr_sequencia,
					nr_atendimento,
					dt_entrada_unidade,
					nr_laudo,
					nm_usuario,
					dt_atualizacao,
					cd_medico_resp,
					qt_imagem,
					nr_seq_pac_prot_ext,
					ds_titulo_laudo,
					dt_laudo,
					cd_pessoa_fisica,
					dt_exame)
	values (nr_seq_laudo_w,
				nr_atendimento_w,
				dt_exame_w,
				nr_laudo_w,
				nm_usuario_p,
				clock_timestamp(),
				cd_medico_w,
				0,
				nr_Seq_pac_protocolo_p,
				ds_procedimento_w,
				dt_exame_w,
				cd_pessoa_fisica_w,
				dt_exame_w);

	CALL Vincular_Procedimento_Laudo(nr_seq_laudo_w,'N',nm_usuario_p);				
	
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_laudo_protocolo_externo ( nr_Seq_pac_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
