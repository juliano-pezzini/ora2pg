-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_trib_tit_receber (nr_seq_nf_saida_p titulo_receber.nr_seq_nf_saida%type, nm_usuario_p titulo_receber.nm_usuario%type) AS $body$
DECLARE


nr_seq_nf_saida_w titulo_receber.nr_seq_nf_saida%type not null := nr_seq_nf_saida_p;
nm_usuario_w titulo_receber.nm_usuario%type not null := nm_usuario_p;
nr_titulo_w titulo_receber.nr_seq_nf_saida%type;
ie_retencao_s_w constant nota_fiscal_trib.ie_retencao%type := 'S';
ie_retencao_d_w constant nota_fiscal_trib.ie_retencao%type := 'D';
ie_retencao_n_w constant nota_fiscal_trib.ie_retencao%type := 'N';
ie_origem_tributo_s_w constant titulo_receber_trib.ie_origem_tributo%type := 'S';
ie_origem_tributo_c_w constant titulo_receber_trib.ie_origem_tributo%type := 'C';
ie_origem_tributo_cd_w constant titulo_receber_trib.ie_origem_tributo%type := 'CD';
qtd_registros_w constant integer := 1000;

c01 CURSOR FOR
    SELECT nr_sequencia, cd_tributo, tx_tributo, vl_base_calculo, vl_tributo,
           vl_base_adic, vl_base_nao_retido, vl_trib_nao_retido, vl_trib_adic,
           case
            when ie_retencao = ie_retencao_n_w then ie_origem_tributo_c_w
            when ie_retencao = ie_retencao_d_w then ie_origem_tributo_cd_w
            when ie_retencao = ie_retencao_s_w then ie_origem_tributo_s_w
           else ie_origem_tributo_c_w end ie_retencao
    from nota_fiscal_trib
    where nr_sequencia = nr_seq_nf_saida_w;

type c01_type   is table of c01%rowtype;
c01_reg_w   c01_type;

BEGIN
    <<recuperar_numero_titulo>>
    BEGIN
        select min(nr_titulo)
        into STRICT nr_titulo_w
        from titulo_receber
        where nr_seq_nf_saida = nr_seq_nf_saida_w;
        exception
            when no_data_found then
                nr_titulo_w := null;
    END;

    IF (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') Then

        delete from titulo_receber_trib
        where nr_titulo = nr_titulo_w;

        $if dbms_db_version.version = 10 $then
            
            <<loop_insert>>
            FOR add_trib_tit in c01 LOOP

                INSERT INTO titulo_receber_trib(
                    nr_sequencia,
                    nr_titulo,
                    vl_trib_adic,
                    vl_trib_nao_retido,                    
                    vl_base_calculo,
                    vl_tributo,
                    cd_tributo,
                    vl_base_adic,
                    vl_base_nao_retido,
                    ie_origem_tributo,
                    dt_atualizacao,
                    nm_usuario) 
                VALUES (
                    nextval('titulo_receber_trib_seq'),
                    nr_titulo_w,
                    add_trib_tit.vl_trib_adic,
                    add_trib_tit.vl_trib_nao_retido,
                    add_trib_tit.vl_base_calculo,
                    add_trib_tit.vl_tributo,
                    add_trib_tit.cd_tributo,
                    add_trib_tit.vl_base_adic,
                    add_trib_tit.vl_base_nao_retido,
                    add_trib_tit.ie_retencao,
                    clock_timestamp(),
                    nm_usuario_w);
            END LOOP loop_insert;
        
        $else

            OPEN c01;
            LOOP
                FETCH c01 BULK COLLECT INTO c01_reg_w LIMIT qtd_registros_w;
                EXIT when c01_reg_w.count = 0;

                FORALL i IN c01_reg_w.FIRST .. c01_reg_w.LAST
    
                    INSERT INTO titulo_receber_trib(
                        nr_sequencia,
                        nr_titulo,
                        vl_trib_adic,
                        vl_trib_nao_retido,                    
                        vl_base_calculo,
                        vl_tributo,
                        cd_tributo,
                        vl_base_adic,
                        vl_base_nao_retido,
                        ie_origem_tributo,
                        dt_atualizacao,
                        nm_usuario) 
                    VALUES (
                        nextval('titulo_receber_trib_seq'),
                        nr_titulo_w,
                        c01_reg_w[i].vl_trib_adic,
                        c01_reg_w[i].vl_trib_nao_retido,
                        c01_reg_w[i].vl_base_calculo,
                        c01_reg_w[i].vl_tributo,
                        c01_reg_w[i].cd_tributo,
                        c01_reg_w[i].vl_base_adic,
                        c01_reg_w[i].vl_base_nao_retido,
                        c01_reg_w[i].ie_retencao,
                        clock_timestamp(),
                        nm_usuario_w);

            END LOOP;
            CLOSE c01;

        $end

        atualizar_saldo_tit_rec(nr_titulo_w,nm_usuario_w);

    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_trib_tit_receber (nr_seq_nf_saida_p titulo_receber.nr_seq_nf_saida%type, nm_usuario_p titulo_receber.nm_usuario%type) FROM PUBLIC;

