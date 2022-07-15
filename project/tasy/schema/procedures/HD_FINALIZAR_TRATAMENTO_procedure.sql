-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_finalizar_tratamento (nr_seq_tratamento_p bigint, dt_fim_tratamento_p timestamp, nr_seq_motivo_p bigint, nr_seq_causa_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


cd_pessoa_fisica_w  	    varchar(10);
count_w         	        varchar(1);
nr_equipe_paciente  	    bigint;
lista_itens_w		          varchar(4000);
ie_hor_suspenso_w	        boolean;
dt_entrada_w		          atend_paciente_unidade.dt_entrada_unidade%type := clock_timestamp();
ds_lista_proc_susp_out_w	varchar(4000);


BEGIN

    if (nr_seq_tratamento_p IS NOT NULL AND nr_seq_tratamento_p::text <> '') then
      select  max(cd_pessoa_fisica)
      into STRICT    cd_pessoa_fisica_w
      from    paciente_tratamento
      where   nr_sequencia = nr_seq_tratamento_p;

      select CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END 
      into STRICT    count_w
      from    motivo_fim
      where   ie_tipo_tratamento = 'O'
      and nr_sequencia = nr_seq_motivo_p;
    
    
      if (count_w = 'S') then
        declare
          nr_tratamento CURSOR FOR 
          SELECT nr_sequencia from paciente_tratamento 
          where cd_pessoa_fisica = cd_pessoa_fisica_w
          and coalesce(dt_final_tratamento::text, '') = '';

          nr_tratamento_sequencia nr_tratamento%rowtype;

        begin
          open nr_tratamento;
            loop
            fetch nr_tratamento
            into nr_tratamento_sequencia;
            EXIT WHEN NOT FOUND; /* apply on nr_tratamento */
            update  paciente_tratamento
            set dt_final_tratamento = dt_fim_tratamento_p,
              nr_seq_motivo_fim   = nr_seq_motivo_p,
              nr_seq_causa_morte  = nr_seq_causa_p,
              nm_usuario  = nm_usuario_p,
              ds_observacao       = coalesce(ds_observacao_p,ds_observacao),
              dt_atualizacao = clock_timestamp()
            where   nr_sequencia = nr_tratamento_sequencia.nr_sequencia;
            end loop;
          close nr_tratamento;
        end;

        -- DESCARTE DIALIZADOR
        declare
          nr_dializador CURSOR FOR 
            SELECT nr_sequencia from hd_dializador
            where cd_pessoa_fisica = cd_pessoa_fisica_w
            and coalesce(ie_motivo_descarte::text, '') = ''
            and coalesce(dt_descarte::text, '') = '';

            nr_dializador_sequencia nr_dializador%rowtype;

        begin
          open nr_dializador;
            loop
            fetch nr_dializador
            into nr_dializador_sequencia;
            EXIT WHEN NOT FOUND; /* apply on nr_dializador */
		        update  hd_dializador
		        set	ie_status		= 'D',
                    dt_descarte		= clock_timestamp(),
          			ie_motivo_descarte   	= 'PO',
           			dt_atualizacao		= clock_timestamp(),
          			nm_usuario		= nm_usuario_p,
          			cd_pf_descarte		= substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10)
            where   nr_sequencia = nr_dializador_sequencia.nr_sequencia;
            end loop;
          close nr_dializador;
        end;

        -- DESCARTE ESCALA
        declare
          nr_escala CURSOR FOR 
            SELECT nr_sequencia from hd_escala_dialise
            where cd_pessoa_fisica = cd_pessoa_fisica_w
            and coalesce(dt_fim::text, '') = '';

          nr_escala_sequencia nr_escala%rowtype;

        begin
          open nr_escala;
            loop
            fetch nr_escala
            into nr_escala_sequencia;
            EXIT WHEN NOT FOUND; /* apply on nr_escala */
        		update  hd_escala_dialise
        		set	dt_fim		= clock_timestamp(),
          			nm_usuario_nrec		= nm_usuario_p
           	where   nr_sequencia = nr_escala_sequencia.nr_sequencia;

        		update   hd_escala_dialise_dia
            set	dt_fim_escala_dia	= clock_timestamp(),
                nr_seq_ponto             = NULL,
           			nm_usuario_nrec		    = nm_usuario_p
            where   nr_seq_escala		= nr_escala_sequencia.nr_sequencia;
            end loop;
          close nr_escala;
        end;

      	-- UPDATE EQUIPE PACIENTE
        declare
          nr_equipe_paciente CURSOR FOR
            SELECT nr_sequencia 
            from hd_equipe_paciente
            where cd_pessoa_fisica = cd_pessoa_fisica_w
            and coalesce(dt_fim::text, '') = '';

          nr_equipe_paciente_sequencia nr_equipe_paciente%rowtype;

        begin
          open nr_equipe_paciente;
            loop
            fetch nr_equipe_paciente
            into nr_equipe_paciente_sequencia;
            EXIT WHEN NOT FOUND; /* apply on nr_equipe_paciente */
        		update  hd_equipe_paciente
        		set	dt_fim		= clock_timestamp(),
          			nm_usuario_nrec		= nm_usuario_p
           	where   nr_sequencia = nr_equipe_paciente_sequencia.nr_sequencia;

            end loop;
          close nr_equipe_paciente;
        end;

      	declare

          nr_cpoe_atendimento CURSOR FOR
          	SELECT		nr_atendimento
          	from		cpoe_dialise
          	where		coalesce(dt_suspensao::text, '') = ''
          	and  		coalesce(dt_lib_suspensao::text, '') = ''
          	and			((dt_fim > clock_timestamp()) or (coalesce(dt_fim::text, '') = ''))
          	and			dt_atualizacao_nrec < dt_entrada_w
          	and 		cd_pessoa_fisica = cd_pessoa_fisica_w
            and (nr_atendimento IS NOT NULL AND nr_atendimento::text <> '')
            group by nr_atendimento
            order by nr_atendimento;

        	nr_cpoe CURSOR(prm_nro_atendimento  cpoe_dialise.nr_atendimento%type) FOR
          	SELECT		nr_sequencia
          	from		cpoe_dialise
          	where		coalesce(dt_suspensao::text, '') = ''
          	and  		coalesce(dt_lib_suspensao::text, '') = ''
          	and			((dt_fim > clock_timestamp()) or (coalesce(dt_fim::text, '') = ''))
          	and			dt_atualizacao_nrec < dt_entrada_w
          	and 		cd_pessoa_fisica = cd_pessoa_fisica_w
            and     nr_atendimento = prm_nro_atendimento;
	
       	  nr_cpoe_sequencia nr_cpoe%rowtype;

      	begin
           --lista_itens_w := null;

           --ie_hor_suspenso_w := true;
        for r_nr_cpoe_atendimento in nr_cpoe_atendimento loop

           lista_itens_w := null;
           ie_hor_suspenso_w := true;
           open nr_cpoe(r_nr_cpoe_atendimento.nr_atendimento);
      	      loop
            	fetch nr_cpoe
            	into  nr_cpoe_sequencia;
            	EXIT WHEN NOT FOUND; /* apply on nr_cpoe */

          		update	cpoe_dialise
          		set dt_suspensao  = clock_timestamp(),
            			dt_lib_suspensao = clock_timestamp(),
            			ie_baixado_por_alta = 'S',
            			dt_alta_medico = clock_timestamp()
           		where nr_sequencia = nr_cpoe_sequencia.nr_sequencia;

              if (coalesce(lista_itens_w::text, '') = '') then
                lista_itens_w :=  nr_cpoe_sequencia.nr_sequencia || ';D;S,';
              else
                lista_itens_w := lista_itens_w || nr_cpoe_sequencia.nr_sequencia || ';D;S,';
              end if;

            	end loop;
          	close nr_cpoe;

            if (ie_hor_suspenso_w) then
               ds_lista_proc_susp_out_w := cpoe_suspender_item_prescr('[' || lista_itens_w || ']', r_nr_cpoe_atendimento.nr_atendimento, nm_usuario_p, null, null, 'N', ds_lista_proc_susp_out_w);
            end if;
        
        end loop;
        end;


    else
        update  paciente_tratamento
        set dt_final_tratamento = dt_fim_tratamento_p,
            nr_seq_motivo_fim   = nr_seq_motivo_p,
            nr_seq_causa_morte  = nr_seq_causa_p,
            nm_usuario  = nm_usuario_p,
            ds_observacao       = coalesce(ds_observacao_p,ds_observacao),
            dt_atualizacao = clock_timestamp()
        where   nr_sequencia = nr_seq_tratamento_p;

        if (count_w = 'S') then
            update   pessoa_fisica
            set  dt_obito = dt_fim_tratamento_p,
            dt_atualizacao = clock_timestamp(),
            nm_usuario = nm_usuario_p
            where  cd_pessoa_fisica = cd_pessoa_fisica_w;
        end if;
    end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_finalizar_tratamento (nr_seq_tratamento_p bigint, dt_fim_tratamento_p timestamp, nr_seq_motivo_p bigint, nr_seq_causa_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

