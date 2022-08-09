-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_med_protocolo_receita ( nr_sequencia_p med_protocolo_receita.nr_sequencia%type) AS $body$
DECLARE


ie_existe_w varchar(1);
nr_seq_novo_w MED_PROTOCOLO_RECEITA.nr_sequencia%type;

BEGIN

select coalesce(max('S'),'N')
into STRICT ie_existe_w
from MED_PROTOCOLO_RECEITA
where nr_sequencia = nr_sequencia_p;

if (ie_existe_w = 'S') then

select nextval('med_protocolo_receita_seq')
into STRICT nr_seq_novo_w
;

insert into MED_PROTOCOLO_RECEITA(
  nr_sequencia,
  DS_PROTOCOLO,
  DT_ATUALIZACAO,
  NM_USUARIO,
  CD_MEDICO,
  DT_ATUALIZACAO_NREC,
  NM_USUARIO_NREC,
  DS_RECEITA,
  IE_SITUACAO
) SELECT
  nr_seq_novo_w,
  substr(obter_desc_expressao(342086) || DS_PROTOCOLO, 1, 40),
  clock_timestamp(),
  wheb_usuario_pck.get_nm_usuario,
  CD_MEDICO,
  clock_timestamp(),
  wheb_usuario_pck.get_nm_usuario,
  '  ',
  'A'
from MED_PROTOCOLO_RECEITA
where nr_sequencia = nr_sequencia_p;

CALL copia_campo_long_de_para(	'MED_PROTOCOLO_RECEITA',
				'DS_RECEITA',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_sequencia_p,
				'MED_PROTOCOLO_RECEITA',
				'DS_RECEITA',
				' where nr_sequencia = :nr_sequencia',
				'nr_sequencia='||nr_seq_novo_w);	

insert into MED_MEDIC_PROTOCOLO(
  NR_SEQUENCIA,
  NR_SEQ_PROTOCOLO,
  NR_SEQ_MEDIC,
  DT_ATUALIZACAO,
  NM_USUARIO,
  NR_SEQ_APRESENT,
  DT_ATUALIZACAO_NREC,
  NM_USUARIO_NREC
) SELECT
  nextval('med_medic_protocolo_seq'),
  nr_seq_novo_w,
  NR_SEQ_MEDIC,
  clock_timestamp(),
  wheb_usuario_pck.get_nm_usuario,
  NR_SEQ_APRESENT,
  clock_timestamp(),
  wheb_usuario_pck.get_nm_usuario
from MED_MEDIC_PROTOCOLO
where NR_SEQ_PROTOCOLO = nr_sequencia_p;

commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_med_protocolo_receita ( nr_sequencia_p med_protocolo_receita.nr_sequencia%type) FROM PUBLIC;
