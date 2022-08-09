-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_add_fav_proc ( nr_sequencia_p text, nm_usuario_p text, nr_atendimento_p bigint) AS $body$
DECLARE


nr_sequencia_ww		varchar(4000);
nr_sequencia_w		proc_pac_descricao.nr_sequencia%type;
item_w			pep_fav_procedimento.nr_sequencia%type;

BEGIN

nr_sequencia_ww := nr_sequencia_p;

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	proc_pac_descricao;

for i in 1..length(nr_sequencia_ww) loop

	if (length(nr_sequencia_ww) > 0) then
		
		item_w := substr(nr_sequencia_ww, 1, position(',' in nr_sequencia_ww) - 1);
		nr_sequencia_ww := substr(nr_sequencia_ww, position(',' in nr_sequencia_ww) + 1, length(nr_sequencia_ww));

		if	(item_w IS NOT NULL AND item_w::text <> '' AND nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
			
			nr_sequencia_w := nr_sequencia_w + 1;
			
			insert	into proc_pac_descricao(nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							cd_profissional,
							nr_atendimento,
							dt_registro,
							cd_procedimento,
							ie_origem_proced,
							ie_situacao,
							qt_procedimento,
							nr_seq_proc_interno,
							cd_doenca,
							ds_descricao)
						(SELECT	nr_sequencia_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							substr(obter_pf_usuario(nm_usuario,'C'),1,10),
							nr_atendimento_p,
							clock_timestamp(),
							cd_procedimento,
							ie_origem_proced,
							'A',
							1,
							nr_seq_proc_interno,
							cd_doenca,
							ds_descricao
						from	pep_fav_procedimento
						where	nm_usuario = nm_usuario_p
						and	nr_sequencia = item_w);
		end if;

	end if;

end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_add_fav_proc ( nr_sequencia_p text, nm_usuario_p text, nr_atendimento_p bigint) FROM PUBLIC;
