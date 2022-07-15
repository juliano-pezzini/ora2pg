-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_almoco_equipe ( nr_seq_equipe_p bigint, nr_seq_motivo_parada_p bigint default null, ie_opcao_p text default 'A', nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


ie_almoco_w 		varchar(2);
nr_seq_motivo_parada_w	bigint;
/*A = almoço
   E = Parada Equipe e Retorno da Equipe*/
BEGIN
if (ie_opcao_p = 'A') then
	select coalesce(ie_almoco,'N')
	into STRICT ie_almoco_w
	from pf_equipe
	where   nr_sequencia = nr_seq_equipe_p;
	if ( ie_almoco_w = 'N') then
		update pf_equipe
		set    ie_almoco = 'S'
		where  nr_sequencia = nr_seq_equipe_p;
	else
		 updatE pf_equipe
		 set    ie_almoco = 'N'
		 where  nr_sequencia = nr_seq_equipe_p;
	end if;
elsif (ie_opcao_p = 'E') then
	select 	coalesce(nr_seq_motivo_parada,0)
	into STRICT 	nr_seq_motivo_parada_w
	from 	pf_equipe
	where   nr_sequencia = nr_seq_equipe_p;

	if ( nr_seq_motivo_parada_w = 0) then 		/*Identifica a parada da equipe*/
		update pf_equipe
		set    nr_seq_motivo_parada = nr_seq_motivo_parada_p
		where  nr_sequencia = nr_seq_equipe_p;

		insert into eme_parada_equipe(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_equipe,
				ie_tipo_parada,
				dt_parada,
				nr_seq_motivo_parada)
		values (	nextval('eme_parada_equipe_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_equipe_p,
				'P',
				clock_timestamp(),
				nr_seq_motivo_parada_p);

	else
		 update pf_equipe				/*Identifica o retorno da equipe*/
		 set    nr_seq_motivo_parada  = NULL
		 where  nr_sequencia = nr_seq_equipe_p;


		 update eme_parada_equipe
		 set    dt_retorno = clock_timestamp()
		 where	nr_seq_equipe = nr_seq_equipe_p
		 and	coalesce(dt_retorno::text, '') = '';


	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_almoco_equipe ( nr_seq_equipe_p bigint, nr_seq_motivo_parada_p bigint default null, ie_opcao_p text default 'A', nm_usuario_p text DEFAULT NULL) FROM PUBLIC;

