-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transferir_pertence_setor ( nm_usuario_p text, nr_seq_registro_p bigint, nr_sequencia_p bigint, cd_setor_atendimeto_p bigint, qt_transacao_p bigint, nr_seq_armario_p bigint default null) AS $body$
DECLARE


qt_libera_registro_w		bigint;			
nr_seq_armario_w		    pertence_paciente.nr_seq_armario%type;
ie_param_29             varchar(1);
			

BEGIN

insert into	pertence_pac_item_evento(
				nr_sequencia,
				nr_seq_pert_pac,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_tipo_evento,
				qt_transacao,
				cd_setor_atendimento,
				nr_seq_armario)
			values (
				nextval('pertence_pac_item_evento_seq'),
				nr_sequencia_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				'T',
				qt_transacao_p,
				cd_setor_atendimeto_p,
				nr_seq_armario_p);


commit;

select	count(*)
into STRICT	qt_libera_registro_w

where (SELECT	count(*)
	from	pertence_paciente_item 
	where	nr_seq_pertence_paciente = nr_seq_registro_p) = (select count(*) 
								  from 	pertence_paciente_item a,
									pertence_pac_item_evento b
								  where	a.nr_seq_pertence_paciente = nr_seq_registro_p
							          and	b.nr_seq_pert_pac = a.nr_sequencia
								  and	b.cd_tipo_evento = 'T');
								
if (qt_libera_registro_w = 1) then
begin
  update	pertence_paciente
  set	dt_lib_recebimento = clock_timestamp()
  where	nr_sequencia = nr_seq_registro_p;

  ie_param_29 := obter_param_usuario(991, 29, obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_param_29);
  if ie_param_29 = 'S' then
     select max(nr_seq_armario) into STRICT nr_seq_armario_w from pertence_paciente where	nr_sequencia = nr_seq_registro_p;
     update armario_pertence set IE_LIVRE = 'S' where nr_sequencia = nr_seq_armario_w;
  end if;
end;
	
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transferir_pertence_setor ( nm_usuario_p text, nr_seq_registro_p bigint, nr_sequencia_p bigint, cd_setor_atendimeto_p bigint, qt_transacao_p bigint, nr_seq_armario_p bigint default null) FROM PUBLIC;
