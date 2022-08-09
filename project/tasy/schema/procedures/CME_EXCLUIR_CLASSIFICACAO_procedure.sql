-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_excluir_classificacao ( ds_classificacao_p text, ds_lista_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_classificacao_w	cm_classif_conjunto.nr_sequencia%type;
nr_seq_conjunto_w	    cm_conjunto.nr_sequencia%type;
ds_classificacao_w		cm_classif_conjunto.ds_classificacao%type;
qt_existe_w				integer;
existe_conjunto_w       integer;
ds_mensagem_w           varchar(255);

C01 CURSOR FOR
	SELECT	    nr_sequencia
	from	    cm_classif_conjunto
	where (obter_se_contido(nr_sequencia, ds_classificacao_p) = 'S')
	order by	nr_sequencia;

C02 CURSOR FOR
	SELECT	    nr_sequencia
	from	    cm_conjunto
	where	    nr_seq_classif = nr_seq_classificacao_w;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_classificacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	    ds_classificacao
	into STRICT	    ds_classificacao_w
	from	    cm_classif_conjunto
	where	    nr_sequencia = nr_seq_classificacao_w;

	open C02;
	loop
	fetch C02 into
		nr_seq_conjunto_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		ds_lista_p     => ds_lista_p := CME_excluir_conjunto(ds_conjunto_p  => nr_seq_conjunto_w, ds_lista_p     => ds_lista_p, nm_usuario_p   => nm_usuario_p);
		end;
	end loop;
	close C02;

        if (coalesce(ds_lista_p::text, '') = '') then
            begin

            delete from	cm_grupo_classif where nr_seq_classificacao = nr_seq_classificacao_w;

            begin
            select 1
            into STRICT existe_conjunto_w
            from cm_conjunto a,
            cm_classif_conjunto b
            where a.nr_seq_classif = b.nr_sequencia
            and b.nr_sequencia = nr_seq_classificacao_w  LIMIT 1;
            exception
            when no_data_found then
            existe_conjunto_w := 0;
            end;

            if (existe_conjunto_w = 1) then
                begin
                    ds_lista_p := WHEB_MENSAGEM_PCK.get_texto(nr_seq_mensagem_p     => 1187362,
                                                              Vl_Macros_P           => 'NR_SEQ_CLASSFICACAO= ' || nr_seq_classificacao_w || ';DS_CLASSIFICACAO= '|| ds_classificacao_w);
                end;
            else
                begin
                    begin
                    select	1
                    into STRICT	qt_existe_w
                    from	cm_classif_conjunto
                    where	nr_sequencia = nr_seq_classificacao_w  LIMIT 1;
                    exception
                    when no_data_found then
                    qt_existe_w := 0;
                    end;

                    if (qt_existe_w = 1) then
                        delete from cm_classif_conjunto where nr_sequencia = nr_seq_classificacao_w;

                        ds_mensagem_w := WHEB_MENSAGEM_PCK.get_texto(nr_seq_mensagem_p => 1188353,
                                                                     Vl_Macros_P     => 'NR_SEQ_CLASSIFICACAO= ' || nr_seq_classificacao_w ||
                                                                     ';DS_CLASSIFICACAO= ' || ds_classificacao_w);

                        CALL gravar_log_exclusao(nm_tabela_p     => 'CM_CLASSIF_CONJUNTO',
                                            nm_usuario_p    =>nm_usuario_p,
                                            ds_chave_p      => ds_mensagem_w,
                                            ie_executar_commit_p => 'S');
                    end if;
                end;
            end if;
            end;
        elsif (ds_lista_p IS NOT NULL AND ds_lista_p::text <> '') then
                ds_lista_p := WHEB_MENSAGEM_PCK.get_texto(nr_seq_mensagem_p => 1187370,
                                                          Vl_Macros_P => 'NR_SEQ_CLASSFICACAO= ' || nr_seq_classificacao_w ||
                                                          ';DS_CLASSIFICACAO= '|| ds_classificacao_w || ';DS_LISTA= ' || ds_lista_p);
        end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_excluir_classificacao ( ds_classificacao_p text, ds_lista_p INOUT text, nm_usuario_p text) FROM PUBLIC;
